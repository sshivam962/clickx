# frozen_string_literal: true

class Agency::SettingsController < Agency::BaseController
  before_action :perform_authorization
  before_action :set_agency,
                only: %i[index update update_logo verify_cname change_currency]
  before_action :build_support_members, only: :index
  before_action :build_billing_address, only: :index
  before_action :build_mailing_address, only: :index
  before_action :ensure_logo, only: :update_logo
  before_action :set_plan, only: :branding
  before_action :set_existing_payment, only: :branding
  before_action :fetch_or_build_stripe_credential, only: :index

  def index; end

  def update
    @agency.update_attributes(agency_params)
    if @agency.errors.present?
      flash[:notice] = @agency.errors.full_messages.to_sentence
    else
      if agency_params["mailing_address_attributes"].present?
        MailAddressMailer.mail_address_add(@agency).deliver_now
      end
    end
    redirect_to fallback_location
  end

  def branding
    authorize current_agency, :branding?
    @customer = current_agency.stripe_customer if current_agency.customer_id
    if @customer && !@customer.deleted?
      @cards =
        @customer.sources[:data].select{|source| source[:object].eql?('card')}
    end
    @default_card = @customer&.default_source || 'add_card'
  end

  def update_logo
    image_url =
      Cloudinary::Uploader.upload(
        params[:image], options = {folder: 'agency_logos'}
      )['secure_url']
    @agency.update(params[:logo] => image_url)
  end

  def verify_cname
    @agency.verify_cname
  end

  def change_currency
    @agency.update(currency: params[:currency])
  end

  private

  def perform_authorization
    authorize current_agency, :settings?
  end

  def set_agency
    @agency = current_agency
  end

  def agency_params
    params.require(:agency).permit(
      :id, :name, :address, :phone, :support_email, :yext_api_key, :domain, :readymode_url, :time_zone_name, :start_time, :end_time,
      :weburl, :white_label_name, :calendly_script, :facebook_pixel, :thank_you_facebook_pixel, 
      :thank_you_funnel, :cold_email_domain_name, :icebreaker_sentence, :ai_bot_prompt_1, :ai_bot_prompt_2, :ai_bot_prompt_3, :display_currency, :funnel_calendlie, 
      :case_study_portfolio_header_color, :strategy_product_header_color, :strategy_product_background_color,
      :questionnaire_header_color, :strategy_product_text_color, :roi_header_color, 
      :casestudy_calender_header, :portfolio_calender_header, :lead_calender_header, 
      support_members_attributes: [:id, :name, photo_attributes: [:id, :file]],
      billing_address_attributes: [
        :id, :first_name, :last_name, :address_line_1, :address_line_2, :city,
        :country, :zip, :state
      ],
      mailing_address_attributes: [
        :id, :first_name, :last_name, :address_line_1, :address_line_2, :city,
        :country, :zip, :state
      ]
    )
  end

  def build_support_members
    sm_count = @agency.support_members.count
    return if sm_count > 1

    (2 - sm_count).times { @agency.support_members.build }
  end

  def build_billing_address
    return if @agency.billing_address

    @agency.build_billing_address(country: 'United States')
  end
  
  def build_mailing_address
    return if @agency.mailing_address

    @agency.build_mailing_address(country: 'United States')
  end

  def ensure_logo
    logos = %w[logo square_logo email_logo grader_logo favicon]
    return if logos.include?(params[:logo])

    redirect_to branding_agency_settings_path
  end

  def fallback_location
    return '/a/settings/branding' if params[:section].eql?('branding')

    '/a/settings'
  end

  def set_plan
    @plan =
      Plan.find_by(package_type: 'agency_domain_management', key: 'basic_v2')
  end

  def set_existing_payment
    @existing_payment = current_agency.package_subscriptions.exists?(
      plan_id: @plan.stripe_plan
    ) || current_agency.eligible_for_free_custom_domain?
  end

  def fetch_or_build_stripe_credential
    @stripe_credential =
      current_agency.stripe_credential || current_agency.build_stripe_credential
  end
end
