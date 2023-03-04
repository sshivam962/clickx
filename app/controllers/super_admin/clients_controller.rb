# frozen_string_literal: true

class SuperAdmin::ClientsController < ApplicationController
  include SuperAdmin::ClientQueryBuilder

  before_action :perform_authorization
  before_action :set_client,
                only: %i[
                  questionnaires update_home_link destroy edit clear_yext_cache
                  update update_customer add_subscription_account activities
                  connect_semrush_project disconnect_semrush_project
                ]
  before_action :set_archived_client, only: %i[unarchive force_delete]
  before_action :set_subscription, only: :questionnaires

  layout 'base'

  def questionnaires
    @questionnaires =
      @client.questionnaires_by_categories(
        @subscription.package.questionnaire_categories
      )
  end

  def archived
    @clients = Business.includes(:agency)
                       .only_deleted.search_by_name(params[:name].to_s)
                       .order(:name)
                       .paginate(page: params[:page], per_page: 20)
  end

  def unarchive
    @client&.restore
  end

  def force_delete
    @client&.really_destroy!
  end

  def client_sheet
    @clients =
      Business.includes(
        :normal_users, :active_package_subscriptions, :competitions
      ).order(:name)
    render(
      xlsx: 'client_sheet',
      filename: "Clients List - #{Time.now.strftime('%b %d, %Y')}.xlsx"
    )
  end

  def update_home_link
    @client.update(home_link: params[:business][:home_link])
  end

  def index
    @clients =
      if @filter_labels.present?
        Business.includes(:labels, :agency, :taggings)
                .references(:agency)
                .where(search_query)
                .where(filter_query)
                .tagged_with(@filter_labels, any: true)
                .order(name: :asc)
                .paginate(page: params[:page], per_page: 30)
      else
        Business.includes(:labels, :agency, :taggings)
                .references(:agency)
                .where(search_query)
                .where(filter_query)
                .order(name: :asc)
                .paginate(page: params[:page], per_page: 30)
      end
  end

  def destroy
    deleted_client_params = [@client.id, @client.name, @client.locale]
    if @client.update(deleted_at: Time.current)
      BusinessOnDeleteSendDetailsJob.perform_async(*deleted_client_params)
    end
  end

  def edit; end

  def remove_user
    @user = User.find(params[:user_id])
    @user.destroy
  end

  def clear_yext_cache
    @locations = @client.locations.where.not(yext_store_id: EMPTY)
    @locations.update_all(yext_listings: {})
  end

  def update
    @client.update(client_params)
  end

  def update_customer
    if params[:customer_id].present?
      @customer = Stripe::Customer.retrieve(params[:customer_id])
      unless @client.update(customer_id: @customer.id)
        @error = @client.errors.full_messages.to_sentence
      end
    else
      @error = 'Please enter a valid Customer Id'
    end
  rescue Stripe::InvalidRequestError => e
    @error = e.json_body[:error][:message]
  end

  def add_subscription_account
    if params[:subscription_id].present?
      @stripe_sub = Stripe::Subscription.retrieve(params[:subscription_id])
      if !%w[active trialing].include? @stripe_sub.status
        @error = 'Not an active subscription'
      elsif @stripe_sub.customer != @client.customer_id
        @error = 'Not the subscription of specified customer'
      end
      SubscriptionService.process(subscription: @stripe_sub)
    else
      @error = 'Please enter a valid Customer Id'
    end
  rescue Stripe::InvalidRequestError => e
    @error = e.json_body[:error][:message]
  end

  def traction
    normal_traction = Business.unscoped.unarchived
                              .group_by_month('businesses.created_at').count
    free_traction = Business.unscoped.unarchived.free
                            .group_by_month('businesses.created_at').count

    x_all = (normal_traction.keys + free_traction.keys).uniq.sort
    x_all.each do |x|
      normal_traction[x] = normal_traction[x].presence || 0
      free_traction[x] = free_traction[x].presence || 0
    end

    y_normal = normal_traction.values
    y_normal.to_enum.with_index.map do |y, z|
      z > 0 ? y_normal[z] += y_normal[z - 1] : y
    end

    y_free = free_traction.values
    y_free.to_enum.with_index.map do |y, z|
      z > 0 ? y_free[z] += y_free[z - 1] : y
    end

    x_axis = x_all.map{ |x| x.strftime('%b %Y') }
    gon.traction_data = { x_axis: x_axis, y_normal: y_normal, y_free: y_free }
  end

  def activities
    @activities =
      @client.activities
             .order(created_at: :desc)

    @activities_info = @activities.map do |activity|
      activity.date = activity.created_at.strftime('%m-%d-%Y')
      activity.num_rows = activity.revisions.length
      activity.human_date = activity.created_at.strftime(
        "%a, %b #{activity.created_at.day.ordinalize} %Y, %I:%M:%S %p"
      )

      activity
    end

    if @activities_info.length > 0
      @activities_group =
        @activities_info.group_by{ |activity| activity.date }
      @activities_group_keys = @activities_group.keys
      @activities_group_length = @activities_group.length
    end
  end

  def disconnect_semrush_project
    if @client.update(semrush_project_id: nil)
      @client.semrush_keywords.delete_all
      render json: { status: 200 }
    else
      render json: { status: 400, data: @client.errors.full_messages }
    end
  end

  def connect_semrush_project
    render json: {
      status: :unprocessable_entity,
      message: 'Invalid Project Key.'
    } and return if params[:semrush_project_id].blank?

    response = Semrush.fetch_project(params[:semrush_project_id])
    status = response['status']
    url = response['url']

    if status.eql?(200)
      @client.semrush_project_url = url

      if @client.update(semrush_project_id: params[:semrush_project_id])
        SemrushKeywordsJob.perform_async(@client.id)

        render json: {
          status: 200,
          message: 'Project Connected Successfully.'
        }
      else
        render json: {
          status: :unprocessable_entity,
          data: @client.errors.full_messages
        }
      end
    else
      render json: {
        status: :unprocessable_entity,
        message: 'Invalid Project Key.'
      }
    end
  end

  private

  def set_client
    @client ||= Business.includes(:users).find(params[:id])
  end

  def set_archived_client
    @client ||= Business.only_deleted.find_by(id: params[:id])
  end

  def set_subscription
    @subscription = PackageSubscription.find(params[:subscription_id])
  end

  def perform_authorization
    authorize %i[super_admin client]
  end

  def client_params
    params.require(:business).permit(
      :id, :name, :agency_id, :local_profile_service, :seo_service,
      :keyword_limit, :site_audit_service, :tracking_page_path,
      :call_analytics_service, :call_analytics_id,
      :contents_service, :trial_service, :trial_expiry_date,
      :competitors_service,
      :site_url, :adword_client_id, :adword_cost_markup, :fb_ad_cost_markup,
      :free_service, :bright_local_report_id, :target_city, :backlink_service,
      :domain, :total_pages_crawled, :managed_seo_service,
      :managed_ppc_service, :competitors_limit, :timezone,
      :reputation_service, :custom_plan_id, :locale,
      label_list: []
    )
  end
end
