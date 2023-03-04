# frozen_string_literal: true

class SuperAdmin::AgenciesController < ApplicationController
  include GoogleAgency
  include GoogleAnalytics
  include DateUtils
  include AgencyPackageManager
  include SuperAdmin::AgencyFilterManager

  before_action :perform_authorization
  before_action :set_archived_agency, only: %i[unarchive force_delete download]

  layout 'base'
  before_action :get_current_user
  before_action :check_if_super_admin_or_agency_admin, except: :show
  before_action :get_agency,
                only: %i[
                  show edit update destroy get_users check_user agency_admins
                  add_client verify_cname invite_admin update_home_link
                  manage_growth_subscription downgrade_plan approve_signup
                  profile scale_zoom update_scale_zoom_weeks change_agency_status
                ]
  before_action :check_agency_of_current_user, only: :show
  before_action :ga_dates, only: %i[get_businesses get_google_analytic_data]
  before_action :check_user, only: [:get_businesses]
  before_action :set_subscription_schedule,
                only: %i[edit manage_growth_subscription]
  before_action :set_active_subscription,
                only: %i[edit manage_growth_subscription downgrade_plan]

  def archived
    @agencies = Agency.only_deleted.search_by_name(params[:name].to_s).reorder(deleted_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  def demo_agency
    @agencies = Agency.select { |agency| agency if agency.name == "ABC Agency Services".to_s || agency.name == "Infinity Marketing".to_s}
  end

  def download
    send_data(
      open(@agency.deleted_agreements.first.file.url).read,
      filename: 'agreement.pdf',
      type: 'application/pdf',
      disposition: 'attachment'
    )
  end

  def agency_sheet
    @agencies =
      Agency.includes(
        :active_package_subscriptions, :normal_users, :businesses, :leads
      ).where(filter_query).order(:name)

    render(
      xlsx: 'agency_sheet',
      filename: "Agencies List - #{Time.now.strftime('%b %d, %Y')}.xlsx"
    )
  end

  def unarchive
    @agency.restore
    @agency.users.with_deleted.map(&:restore)
    @agency.create_clickx_user if @agency.preview_users.blank?
    @agency.destroy unless @agency.save
  end

  def force_delete
    @agency.really_destroy!
    redirect_to archived_super_admin_agencies_path
    flash[:notice] = "Agency #{@agency.name} deleted"
  end

  def index
    if get_cookie(:agency_filters)[:is_paid] == "true"
      
      @agencies =
        Agency.includes(:users, :growth_subscriptions).references(:users)
              .where(filter_query).reorder(created_at: :desc)
              .paginate(page: params[:page], per_page: 30)
    else
      @agencies =
        Agency.includes(:users).references(:users).joins(:growth_subscriptions)
              .where(filter_query).reorder(created_at: :desc)
              .paginate(page: params[:page], per_page: 30)
    end
  end

  def show
    render json: @agency.as_json
  end

  def new
    @agency = Agency.new
    @agency.build_outscraper_limit
  end

  def edit
    @subscriptions =
      @agency.package_subscriptions.stripe.priority_order
  end

  def invite_admin
    @agency_admin = @agency.users.new(role: 'agency_admin')
  end

  def create
    set_fulfilment_courses
    if @courses.present?
      params['agency']['course_ids']  = params['agency']['course_ids'] + @courses
    end
    @agency = Agency.new(agency_params)
    if @agency.save
      AdminMailer.new_agency(@agency.id, current_user.id).deliver_later
      redirect_to super_admin_agencies_path
    else
      redirect_to edit_super_admin_agency_path(@agency)
    end
  end

  def update
    set_fulfilment_courses
    if @courses.present?
      params['agency']['course_ids']  = params['agency']['course_ids'] + @courses
    end
    if @agency.update_attributes(agency_params)
      subscribe_package if params[:agency][:package].present?
      update_fixed_plan

      Hubspot.configure(
        client_id: ENV['HUBSPOT_CLIENT_ID'],
        client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
        redirect_uri: auth_hubspot_callback_url,
        access_token: HubspotAuth.get_access_token
      )

      @agency.users.normal.each do |user|
        scale_program = user.ownable_agency.scale_program ? 'Yes' : 'No'
        contact_properties = { scale_program: scale_program }
        Hubspot::Contact.create_or_update(user.email, contact_properties)
      end
      redirect_to super_admin_agencies_path
    else
      redirect_to edit_super_admin_agency_path(@agency)
    end
  end

  def change_agency_status
    agency_status = false
    if @agency.agency_status == false
      agency_status = true
    else
      agency_status = false
    end
    @agency.update(agency_status: agency_status)

    redirect_to super_admin_agencies_path
  end

  def destroy
    @agency.update(
      name_slug: "#{@agency.name_slug}-archived-#{@agency.id}"
    )
    @agency.destroy

    Hubspot.configure(
      client_id: ENV['HUBSPOT_CLIENT_ID'],
      client_secret: ENV['HUBSPOT_CLIENT_SECRET'],
      redirect_uri: auth_hubspot_callback_url,
      access_token: HubspotAuth.get_access_token
    )

    contact_properties = { clickx_agency_partner_user: 'Canceled Account' }
    @agency.users.normal.each do |user|
      Hubspot::Contact.create_or_update(user.email, contact_properties)
    end

    # do this after updating hubspot contact
    @agency.normal_users.map(&:really_destroy!)

    redirect_to super_admin_agencies_path
  end

  def get_businesses
    analytics = get_agency_dashboard_data agency_id: params[:agency_id],
                                          page_number: params[:page][:number],
                                          offset: params[:page][:size]
    agency = Agency.find params[:agency_id]
    total_pages = (agency.businesses.count / params[:page][:size].to_f).ceil
    render json: { analytics: analytics, total_pages: total_pages,
                   business_count:  agency.businesses.count }
  end

  def get_users
    @users = @agency.users.normal
    render json: { agency_users: @users }
  end

  def check_user
    render json: { errors: 'Access Denied' }, status: 403 and return unless (params[:agency_id].to_i == current_user.ownable_id && current_user.agency_admin?) || current_user.super_admin?
  end

  def agency_admins
    @agency_admins = @agency.users.normal
  end

  def add_client
    @business = @agency.businesses.create(business_params)
    if @business.persisted?
      render json: { business: @business }, status: :created
    else
      render json: { business: @business,
                     errors: @business.errors.full_messages.to_sentence },
             status: :not_acceptable
    end
  end

  def update_client
    @business = Business.find(business_params[:id])
    if @business.update(business_params)
      create_onboarding_procedures
      render json: { status: 200,
                     business: @business }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @business.errors }
    end
  end

  def destroy_client
    @business = Business.find(params[:business_id])
    if @business.update(deleted_at: Time.current)
      render json: { status: 200 }
    else
      render json: { status: 406,
                     business: @business,
                     errors: @business.errors.full_messages }
    end
  end

  def add_keywords
    @business = Business.find(params[:business_id])
    @business.update(business_params)
    params[:keywords]&.each do |keyword|
      @business.keywords.find_or_create_by(name: keyword)
    end
    render json: { status: 200 }
  rescue StandardError
    render json: { status: 404 }
  end

  def get_agency_limits
    @agency = Agency.includes(:businesses).find(params[:id])
    biz_id = params[:business_id]

    used_keywords = @agency.businesses.where.not(id: biz_id).sum(:keyword_limit)
    used_competitors = @agency.businesses
                              .where.not(id: biz_id)
                              .sum(:competitors_limit)
    used_clients = @agency.businesses.count

    keyword_limit = Keyword.where(business_id: biz_id).count
    competitors_limit = Competition.where(business_id: biz_id)
                                   .count

    render json: { used_keywords: used_keywords,
                   used_competitors: used_competitors,
                   used_clients: used_clients,
                   keyword_limit: keyword_limit,
                   competitors_limit: competitors_limit }
  end

  def verify_cname
    @agency.verify_cname
  end

  def update_home_link
    @agency.update(home_link: params[:agency][:home_link])
  end

  def manage_growth_subscription; end

  def downgrade_plan
    @subscription_schedule =
      PackageDowngradeService.process(
        agency: @agency, plan_id: params[:downgrade_plan],
        active_subscription: @active_subscription
      )
  rescue StandardError => e
    @error =  e.message
  end

  def verified_domains
    @agencies =
      Agency.where(cname_verified: true).where.not(cname: EMPTY)
            .search_by_name(params[:name].to_s).order(:name)
            .paginate(page: params[:page], per_page: 20)
  end

  def approve_signup
    @agency.update(signup_approved: true)
    @agency.users.normal.last.deliver_invitation
    SignupMailer.agency_welcome_email(@agency).deliver_later

    redirect_to super_admin_agencies_path
  end

  def profile
    @profile = @agency.agency_profile
  end

  def scale_zoom; end

  def update_scale_zoom_weeks
    number_of_weeks = params[:scale_zoom_weeks]
    @expiry_date = number_of_weeks.present? && number_of_weeks != '0' ? (Time.current + number_of_weeks.to_i.weeks).strftime('%a, %d %b %Y') : ''
  end

  private

  def set_archived_agency
    @agency ||= Agency.only_deleted.find_by(id: params[:id])
  end

  def set_fulfilment_courses
    @courses = Course.fulfilment_program.where(resource_type: 'agency').map{|c| c.id.to_s }
  end

  def get_agency_dashboard_data(agency_id:, page_number:, offset:)
    data = []
    agency = Agency.find agency_id
    businesses = agency.businesses.page(page_number.to_i || 1).per_page(offset.to_i || 10)
    businesses = businesses.includes(:businesses_users, :users).where('name ilike ?', "%#{params[:filter][:query]}%") if params.dig(:filter, :query)
    businesses.each do |business|
      signature_key = params.merge(type: 'google_analytics_visits_data',
                                   agency_id: agency_id,
                                   business_id: business.id,
                                   start_date: @start_period,
                                   end_date: @end_period,
                                   updated_at: business.updated_at)
      signature = Digest::SHA1.digest(signature_key.to_s)
      resp =
        begin
          APICache.get(signature, cache: Agency::CACHE_DURATION, timeout: 60) do
            get_google_analytic_data business: business
          end
        rescue APICache::CannotFetch => e
          Rails.logger.info "[Agency Dashboard] #{e.message}"
          get_google_analytic_data business: business
        end
      data << resp
    end
    data
  end

  def get_agency
    @agency = Agency.find(params[:id])
  end

  def agency_params
    @p = params.require(:agency).permit(
      :id, :name, :logo, :address, :phone,:support_email, :enable_cold_email, :cold_email_sub_domain, :time_zone_name, :start_time,
      :end_time, :niches, :state, :readymode_enabled,
      :coaching_recordings, :start_agency_program, :email_leads_count_limit,
      :square_logo, :email_logo, :grader_logo, :domain, :white_label_name, :is_social_media_ad, :value_hook, :moment_call,
      :coaching_calls_in_support_page, :clients_limit, :keywords_limit, :weburl, :competitors_limit, :level,
      :support_popup, :yext_api_key, :white_labeled, :portfolio_enabled,
      :connect_call_link, :kickoff_call_link, :prospecting_call_link,
      :allow_client_duplication, :case_study_enabled, :scale_program, :plans_enabled, :scale_zoom_info, :scale_zoom_weeks, :scale_zoom_expiry_date, :legal_name,
      :lead_strategy_limit, :number_of_users, :payment_links_enabled, :bundle_plans, :onetime_charge, :support_prospecting_call,
      :portfolio_limited_access, :case_study_limited_access,
      course_ids: [], enabled_packages: [], enabled_document_categories: [], onboarding_checklist: [],
      support_members_attributes: %i[id name image], labels: [], outscraper_limit_attributes: [:credit_balance, :download_limit, :max_requests]
    )

    @p[:labels] = @p[:labels]&.select(&:present?)&.join(',')

    @p
  end

  def check_agency_of_current_user
    return if current_user.super_admin?
    render json: { errors: 'Access denied' }, status: 406 and return unless @agency == current_user&.businesses&.first&.agency || @agency.id == current_user.ownable_id
  end

  def get_google_auth_client_analytics(_token, business)
    @auth_google_client = auth_google_client(business, Token::AnalyticsAccessToken)
  end

  def get_google_analytic_data(business:)
    analytics = {}
    enable_services = Agency.find_enable_services business
    analytics[:business_id] = business.id
    analytics[:agency_id] = business.agency_id
    analytics[:business_name] = business.name
    analytics[:url] = business.site_url
    analytics[:logo] = business.logo
    analytics[:enable_services] = enable_services
    analytics[:agency_users] = business.users.active.as_json(basic: true)
    analytics[:login_user_id] = business.preview_users.first.id
    analytics
  end

  def visits_agency_data(business, start_date, end_date)
    visits = 0
    if business.google_analytics_id
      begin
        get_visits = google_analytics_visits(business, start_date, end_date)
        start_date.upto(end_date) do |date|
          visit = get_visits[date.to_s.tr('-', '')].to_i
          visits += visit
        end
      rescue StandardError
        nil
      end
    end
    data = { visits: visits }
    data
  end

  def business_package_subscriptions(business)
    business.package_subscriptions
      .pluck(:package_name).map(&:humanize).join(', ')
  end

  def google_analytics_visits(business, start_date, end_date)
    get_google_auth_client_analytics business
    direct_visit_count(@auth_google_client, business.google_analytics_id,
                       start_date.to_s, end_date.to_s)
  end

  def get_google_auth_client_analytics(business)
    @auth_google_client = auth_google_client(business, Token::AnalyticsAccessToken)
  end

  def ga_dates
    @start_period = start_date_from_date_string params[:start_period]
    @end_period = end_date_from_date_string params[:start_period]
    @start_last_period = start_date_from_date_string params[:start_period], compared_to = true
    @end_last_period = end_date_from_date_string params[:start_period], compared_to = true
    render json: { message: 'Invalid date' } unless @start_period && @end_period && @start_last_period && @end_last_period
  end

  def get_percentage(new_value, old_value)
    if old_value.zero?
      0
    else
      (((new_value.to_f - old_value.to_f) / old_value.to_f) * 100.0).round.to_f
    end
  end

  def keyword_params
    params.permit(keywords: [:name]).fetch(:keywords)
  end

  def business_params
    params.require(:business).permit(
      :name, :target_city, :seo_service, :keyword_limit, :site_audit_service,
      :backlink_service, :call_analytics_service, :contents_service,
      :competitors_service, :competitors_limit,
      :logo, :timezone, :domain, :id,
      :reputation_service, :locale
    )
  end

  def create_onboarding_procedures
    return unless params[:business][:onboarding_procedures]
    @business
      .onboarding_procedures
      .where.not(id: params[:business][:onboarding_procedures].pluck(:id))
      .destroy_all
    params[:business][:onboarding_procedures].each do |procedure|
      procedure = OnboardingProcedure.find procedure['id']
      next if procedure['business_id'].present?

      procedure_copy = procedure.amoeba_dup
      procedure_copy.business = @business
      procedure_copy.save
    end
  end

  def update_fixed_plan
    @agency.plan_ids = [params[:agency][:fixed_plan_id]]
  end

  def perform_authorization
    authorize %i[super_admin agency]
  end

  def set_subscription_schedule
    @subscription_schedule = @agency.subscription_schedules.not_started.first
  end

  def set_active_subscription
    @active_subscription = @agency.stripe_active_package
  end
end
