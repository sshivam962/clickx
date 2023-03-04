# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :set_raven_context
  before_action :host_constraint_check
  def https_redirect
    return true unless Rails.env.production? or Rails.env.staging?
    redirect_to protocol: 'https://' if request.protocol.eql?('http://') && !http_only_route?
    true
  end

  include Pundit::Authorization
  include CookieManager
  include GoogleApiAuth
  include ApplicationHelper

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception,
                       except: %w[switch_user_login grader_free_signup], prepend: true

  before_action :https_redirect
  before_action :store_location
  before_action :check_domain
  helper_method :current_business, :current_agency, :themeX?,
                :original_user, :impersonated?, :original_agency
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :change_header, if: ->(_i) { request.format.html? }

  before_action :authenticate_user!
  before_action :set_user_businesses
  before_action :block_other_busineses_in_white_labeled_domain
  before_action :set_paper_trail_whodunnit
  before_action :agency_active_check, if: :agency_admin?

  layout :layout_by_resource

  rescue_from Pundit::NotAuthorizedError do |exception|
    respond_to do |format|
      format.js   { head :forbidden, content_type: 'text/html' }
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, notice: exception.message.first(30) }
    end
  end

  rescue_from Stripe::InvalidRequestError do |exception|
    render json: { status: 406, errors: exception.message }
  end

  rescue_from ActionController::RoutingError do |exception|
    render_error(404, exception)
  end

  rescue_from ActionDispatch::Cookies::CookieOverflow do |exception|
    ErrorNotify.cookies_overflow(cookies.to_json).deliver_now
    render_error(404, exception)
  end

  rescue_from 'AdsCommon::Errors::AuthError' do |_exception|
    render json: {
      status: 401,
      error: 'Your account has been disconnected. Please reconnect to continue'
    }
  end

  def get_current_user
    @user = current_user
  end

  def current_business
    @current_business ||= Business.with_dummy.find_by(id: get_cookie(:current_business_id))
  end

  def current_agency
    @current_agency ||= (
      Agency.find_by(id: get_cookie(:current_agency_id)) ||
      Agency.find_by(id: current_user.ownable_id)
    )
  end

  def set_user_businesses
    current_user&.super_admin? && begin
      @businesses ||= current_user.businesses.pluck(:id, :name).to_json
    end
  end

  def store_location
    # Store visited url - so that user can be taken to that url after login
    return if !request.get? || request.xhr? || devise_controller?
    session[:previous_url] = request.fullpath
  end

  def set_custom_cookies
    clear_cookie(:current_business_id)

    if current_user.super_admin?
      clear_all_user_cookies
    elsif current_user.agency_admin?
      set_cookie(:agency_admin_id, current_user.id)
      set_cookie(:current_agency_id, current_user.ownable_id)
    elsif current_user.business_user?
      if current_user.businesses.count.eql?(1) ||
         (
           white_labeled_client? &&
           current_user.businesses.where(agency_id: current_tenent.id).count.eql?(1)
         )
        business = current_user.businesses&.first
        set_cookie(:current_agency_id, business.agency_id)
        set_cookie(:current_business_id, business.id)
      end
    end
  end

  def after_sign_in_path_for(_scope)
    after_sign_in_path
  end

  def path_to_sign_agreement
    current_agency.agreement&.signed? ? agency_sign_addendum_path : agency_sign_agreement_path
  end

  def agreement_redirect_path
    case current_user.ownable_type
    when 'Agency'
      path_to_sign_agreement
    when 'Business'
      business_sign_agreement_path
    else
      network_sign_agreement_path if current_user.contractor?
    end
  end

  def agreement_not_signed?
    case current_user.ownable_type
    when 'Agency'
      !current_agency.agreement_signed? && current_user.normal?
    when 'Business'
      current_business.present? &&
      current_business.clickx? &&
      current_user.normal? &&
      !current_business.agreement_signed?
    else
      current_user.contractor? &&
      current_user.normal? &&
      !current_user.network_profile&.agreement_signed?
    end
  end

  def agreement_redirect_needed?
    # current_user.sign_in_count.odd? && agreement_not_signed?
    agreement_not_signed?
  end

  def after_sign_in_path(path = nil)
    set_custom_cookies
    return agreement_redirect_path if agreement_redirect_needed?
    return path if path.present?
    if current_user.normal? && current_user.business_user? && current_business
      current_business.update_attributes(last_logged_in: Time.current,
                                         last_logged_in_user: current_user)
    end
    if current_user.super_admin?
      '/s/'
    elsif current_user.contractor?
      '/n/dashboard'
    elsif current_user.agency_admin?
      if current_user.normal? && current_agency
        current_agency.update_attributes(
          last_logged_in: Time.current, last_logged_in_user: current_user
        )
      end
      if current_agency&.inactive?
        agency_packages_growth_path(key: 'agency_infrastructure')
      else
        if current_agency.white_labeled && policy(current_agency).courses?
          '/a/courses'
        else
          agency_clients_path
        end
      end
    elsif session[:previous_url]
      if session[:previous_url].match?(Regexp.new('switch'))
        '/clients/#/select'
      elsif session[:previous_url].include?('email_settings') ||
            session[:previous_url].include?('location_management') ||
            session[:previous_url].include?('campaign_intelligence')
        session[:previous_url]
      else
        '/clients/#/select'
      end
    elsif current_business
      '/b/dashboard'
    else
      '/'
    end
  end

  # Override parameters to be accepted along with devise defined params
  # e.g while sending invitation we accept name, username, role etc
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite) do |u|
      u.permit(:email, :role, :first_name, :last_name,
               :ownable_id, :ownable_type, :agency_super_admin)
    end

    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:login, :email, :password, :remember_me)
    end

    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :phone, :address,
               :password, :current_password, :password_confirmation)
    end
  end

  def user_not_authorized
    render json: { errors: 'Access denied' }, status: 406 and return
  end

  def check_if_super_admin
    return if current_user.super_admin?
    render json: { errors: 'Access denied' }, status: 406 and return
  end

  def check_if_super_admin_or_agency_admin
    return if current_user.super_admin? or current_user.agency_admin?
    render json: { errors: 'Access denied' }, status: 406 and return
  end

  def auth_google_client(business, type = nil)
    auth_client = get_google_client(business, type)
    cookies[:current_page] = nil
    auth_client
  end

  def original_user
    @_original_user ||= begin
      if session[:admin_id].present?
        User.find(session[:admin_id])
      elsif session[:agency_admin_id].present?
        User.find(session[:agency_admin_id])
      else
        current_user
      end
    end
  end

  def original_agency
    @_original_agency ||=
      if session[:agency_admin_id].present?
        @x_user = User.find(session[:agency_admin_id])
        @x_user.ownable
      end
  end

  def impersonated?
    current_user != original_user
  end

  def current_business_dashboard
    redirect_url =
      # Onboarding for only clickx agency clients
      if !current_business
        sign_out_business_user
        '/'
      elsif current_user.sign_in_count.eql?(1) && current_business.clickx?
        "/#/#{current_business.id}/onboarding"
      elsif current_business.free_service?
        '/#/grader'
      else
        '/b/dashboard'
      end
    render json: { status: 200, data: { url: redirect_url } }
  end

  def sign_out_business_user
    flash[:notice] = "We're sorry, we are unable find your account at this moment. Please contact your support agent"
    sign_out(current_user)
  end

  def block_other_busineses_in_white_labeled_domain
    return false unless white_labeled_client?
    return false unless current_business
    return false unless request.get?
    return false unless action_name == 'sign_out'
    if current_business.agency_id != current_tenent.id
      logger.info '[Clickx] Diffrent account , redirecting to index'
      render file: "#{Rails.root}/public/404", status: :not_found
      return
    end
  end

  private

  def host_constraint_check
    return if Rails.env.development?
    return if HOST_CONSTRAINTS.exclude?(request.host)

    redirect_to ENV['PUBLIC_APP_DOMAIN']
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id])
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def change_header
    response.headers.delete('X-Content-Type-Options')
  end

  def check_domain
    return true unless Rails.env.production?
    redirect_to 'https://clickx.io' if redirect_to_home?
  end

  def record_not_found
    logger.info '[Clickx] Record Not found , redirecting to index'
    redirect_to action: :index
  end

  def agency_admin?
    current_user&.agency_admin?
  end

  def agency_active_check
    return true if devise_controller? || current_agency.active?

    redirect_to agency_packages_growth_path(key: 'agency_infrastructure')
  end

  protected

  def redirect_to_home?
    route = request.env['action_dispatch.request.path_parameters']

    case request.env['HTTP_HOST']
    when ENV['REVIEWS_URL']
      !(route[:controller] == 'reviews' &&
          %w[new create].include?(route[:action]))
    end
  end

  def layout_by_resource
    if devise_controller? && resource_name == :user &&
       %w[GET_enable_authy POST_enable_authy GET_verify_authy_installation
          POST_verify_authy_installation].include?(action_name)
      set_user_layout
    elsif params[:controller].eql?('magic/link/magic_links')
      'devise'
    end
  end

  def allow_iframe
    response.headers.except! 'X-Frame-Options'
  end

  def set_user_layout
    if themeX?
      themeX_layout 'themeX_base'
    elsif network?
      'network'
    else
      'base'
    end
  end

  def network?
    current_user.present? && current_user.contractor?
  end

  def user_template
    if themeX?
      lookup_context.find_template("#{controller_path}/#{action_name}")
                    .inspect.gsub('.html', '_themeX.html')
                    .gsub('app/views/', '')
    else
      lookup_context.find_template("#{controller_path}/#{action_name}")
                    .inspect.gsub('app/views/', '')
    end
  end

  def themeX?
    current_user.present? &&
      (current_user.business_user? ||
      current_user.agency_admin?)
  end

  def themeX_layout(layout_name)
    if current_user.agency_admin?
      'aa_themeX_base'
    else
      "bu_#{layout_name}"
    end
  end

  def render_error(status, _exception)
    respond_to do |format|
      format.html { render template: "public/#{status}", layout: false, status: status }
      format.all { render status: status }
    end
  end

  def http_only_route?
    request.env['HTTP_HOST'].match(ENV['SNIP_URL'])
  end

  def export_disabled?
    render json: { status: :not_acceptable } and return if @business.trial_service || @business.free_service
  end

  def https_redirect
    return true unless Rails.env.production? or Rails.env.staging?
    redirect_to protocol: 'https://' if request.protocol.eql?('http://') && !http_only_route?
    true
  end

  def stub_with_dummy_data(business: current_business, key: nil)
    return unless business&.dummy?
    key ||= [controller_name, action_name, params].compact.join('-')
    data = # Rails.cache.fetch(key, expires_in: 1.month) do
      Oj.load File.open(Rails.application.root.join('app', 'dummy', "#{key}.json")).read
    # end
    render json: data and return
  rescue Errno::ENOENT
    return
  end

  def domain_host(url)
    Addressable::URI.parse(url).host
  rescue StandardError
    nil
  end
end
