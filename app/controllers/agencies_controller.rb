# frozen_string_literal: true

class AgenciesController < ApplicationController
  include GoogleAgency
  include GoogleAnalytics
  include DateUtils

  layout :set_user_layout
  before_action :get_current_user
  before_action :check_if_super_admin_or_agency_admin, except: :show
  before_action :get_agency, except: %i[create index get_google_analytic_data get_businesses update_client add_keywords destroy_client get_agency_limits client_questionnaires]
  before_action :check_agency_of_current_user, only: :show
  before_action :ga_dates, only: %i[get_businesses get_google_analytic_data]
  before_action :check_user, only: [:get_businesses]
  before_action -> { authorize @agency, :visible? }, only: %i[
    get_users check_user agency_admins show
  ]
  before_action -> { authorize :agencies, :visible? }, only: %i[
    edit
  ]

  def index
    authorize :agencies, :visible?
    @agencies =
      Agency.includes(:users, :preview_users).where(
        'lower(agencies.name) ILIKE :like_name',
        name: params[:name],
        like_name: "%#{params[:name]}%"
      )
  end

  def show
    render json: @agency.as_json.merge(
      paid_subscription: @agency.has_active_subscription?,
      growth_plan_key: @agency.growth_plan_key,
      dfyelite_remaining_days: @agency.dfyelite_remaining_days
    )
  end

  def edit
    render json: @agency.to_json
  end

  def create
    authorize :agencies, :manage?
    @agency = Agency.new(agency_params)
    if @agency.save
      render json: { status: 201, agency: @agency }
    else
      render json: { status: 406, agency: @agency, errors: @agency.errors }
    end
  end

  def update
    if @agency.update_attributes(agency_params)
      render json: {
        status: 200, agency: @agency, message: 'Agency Updated Successfully'
      }
    else
      render json: {
        status: 406, agency: @agency,
        message: @agency.errors.full_messages.first
      }
    end
  end

  def destroy
    @agency.destroy
    render json: { status: 200 }
  end

  def get_businesses
    authorize Agency.find(params[:agency_id]), :visible?
    analytics = get_agency_dashboard_data agency_id: params[:agency_id],
                                          page_number: params[:page][:number],
                                          offset: params[:page][:size]
    agency = Agency.find params[:agency_id]
    authorize agency, :visible?
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
    render json: @agency.users.as_json(basic: true)
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

  def client_questionnaires
    @business = Business.find(params[:business_id])
    questionnaires = @business.questionnaires_with_links
    render json: {
      status: 200, business: @business, questionnaires: questionnaires,
      errors: @business.errors.full_messages
    }
  end

  private

  def get_agency_dashboard_data(agency_id:, page_number:, offset:)
    data = []
    agency = Agency.find agency_id
    authorize agency, :manage?
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
    params.require(:agency)
          .permit(:id, :name, :logo, :address, :phone,
                  :support_email, :square_logo, :email_logo, :grader_logo,
                  :domain, :legal_name,
                  :white_label_name, :clients_limit, :keywords_limit,
                  :weburl, :competitors_limit, :level, :support_popup,
                  :yext_api_key, :white_labeled,
                  :connect_call_link, :kickoff_call_link, :prospecting_call_link,
                  :allow_client_duplication, support_members_attributes: %i[id name image])
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
      .pluck(:package_name).map(&:titleize).join(', ')
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
end
