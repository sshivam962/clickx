# frozen_string_literal: true

class SignupsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: :client_signup
  before_action :user_present?
  before_action :set_client_plan, only: %i[new_client_signup client_signup]
  before_action :set_coupon, only: %i[client_signup check_coupon]

  # Referrals disabled
  # after_action :set_referrer, only: :client_signup

  before_action :check_eligibility,
                only: %i[client_signup free_signup grader_free_signup]

  layout 'signup'

  def new_smb_signup
    redirect_to business_paid_path(:starter)
  end

  def free
    @user = User.new
    @logo = 'logo-dark.svg'
    @identity = @user.identities.build
  end

  def free_signup
    ActiveRecord::Base.transaction do
      raise 'Email ID already exists' if user_exists?

      if business_params[:domain].present?
        @business = Business.find_by(domain: business_params[:domain])
        raise 'Your domain not is not available as it is already associated with another user. Please fill out the form below:' if @business.present?
      end
      @business = Business.create!(
        business_params.merge!(
          agency: (Agency.clickx || Agency.create(name: 'Clickx')),
          competitors_service: false,
          competitors_limit: 1,
          free_service: true
        )
      )
      via_omniauth and return if user_omniauth_params[:identities_attributes]['0'][:provider].present?
      @user = User.invite!(user_params.merge!(role: 'company_admin',
                                              ownable: @business))
      @business.update_attributes(
        local_profile_service: false, seo_service: false,
        contents_service: false, backlink_service: false,
        label_list: ['Free'], trial_service: false
      )
      CloseioJob.perform_later(@user)
    end
    @msg = 'We look forward to helping you grow your business. Please check your email to continue creating your account!'
    render :signup_response
  rescue StandardError => e
    @msg = e.message
    @error = true
    render :signup_response
  end

  def grader_free_signup
    @agency = Agency.clickx
    ActiveRecord::Base.transaction do
      if user_exists?
        SignupMailer.existing_email(user_params[:email], @agency).deliver_now
        raise 'Email ID already exists'
      end

      @business = Business.create(
        business_params.merge!(
          agency: @agency,
          competitors_service: false,
          competitors_limit: 1,
          free_service: true
        )
      )

      if @business.new_record?
        SignupMailer.existing_domain(user_params[:email], @business.domain, @agency).deliver_now if @business.errors.details.include? :domain
        raise ActiveRecord::Rollback
      end

      @user = User.invite!(user_params.merge!(role: 'company_admin',
                                              ownable: @business))
      @business.update_attributes(
        local_profile_service: false, seo_service: false,
        contents_service: false, backlink_service: false,
        label_list: ['Free'], trial_service: false
      )
      CloseioJob.perform_later(@user)
    end

    render json: {
      code: 200, message: 'success',
      data: {
        user_id: @user&.id,
        business_id: @business.id
      }
    }
  rescue StandardError => e
    render json: { code: 404, message: e.message }
  end

  def new_client_signup; end

  def client_signup
    raise 'Email ID already exists' if user_exists?

    tag = @is_trial ? 'Trial' : 'Software'
    @expiry_date = (Time.current + @plan.trial_period_days.days) if @is_trial

    @business = Business.new(
      business_params.merge!(
        agency: Agency.clickx,
        seo_service: true,
        contents_service: true,
        backlink_service: true,
        label_list: [tag],
        trial_service: @is_trial,
        trial_expiry_date: @expiry_date
      )
    )

    if @business.valid?
      @customer = Stripe::Customer.create(
        email: user_params[:email],
        description: customer_details
      )
      @customer.sources.create(source: credit_card_attrs)

      @stripe_sub = Stripe::Subscription.create(
        customer: @customer.id,
        coupon: @coupon&.coupon_id,
        plan: @plan.plan_id
      )

    else
      raise @business.errors.full_messages.to_sentence
    end

    ActiveRecord::Base.transaction do
      @business.customer_id = @customer.id
      @business.save!
      @old_user = User.deleted.find_by(email: user_params[:email])
      @old_user.really_destroy! if @old_user.present?
      @user = User.invite!(user_params.merge!(role: 'company_admin',
                                              ownable: @business))

      SubscriptionService.process(subscription: @stripe_sub)

      CloseioJob.perform_later(@user)
    end

    SignupMailer.new_signup(business_params.as_json, user_params.as_json, @plan.name).deliver_later
    SignupMailer.welcome_box(business_params.as_json, user_params.as_json, @plan.name).deliver_later
    SignupMailer.new_payment(business_params.as_json, user_params.as_json, @plan.name, @plan.amount).deliver_later
    SignupMailer.new_payment_recieved_sms(business_params.as_json, user_params.as_json, @plan.name, @plan.amount).deliver_later
    redirect_to ENV['THANK_YOU_PAGE']
  rescue StandardError => e
    ErrorNotify.signup_error(
      params.except(:card_token).as_json,
      e.message
    ).deliver_later
    @msg = e.message
    @error = true
    render :signup_response
  end

  def check_coupon
    if @coupon
      total_price = params[:plan_price].to_i
      is_trial = params[:trial_plan] == 'true'
      discount_msg, offer_msg =
        helpers.coupon_applied_info @coupon, total_price, is_trial

      render json: { code: 200, message: discount_msg, offer_msg: offer_msg }
    else
      render json: { code: 404, message: 'Promo Code Not Found' }
    end
  end

  def sorry
    @msg = params[:msg]
  end

  private

  def user_exists?
    User.exists? email: user_params[:email]
  end

  def set_client_plan
    @plan ||= Subscription::Plan.client.find_plan(params[:plan])
    redirect_to free_path unless @plan
    @is_trial = (@plan || false) && @plan.trial?
  end

  def set_coupon
    @coupon ||=
      Subscription::Coupon.active.find_by coupon_id: params[:coupon_code]
  end

  def business_params
    params.require(:business).permit(:name, :domain, :target_city)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone)
  end

  def user_omniauth_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone,
                                 identities_attributes: %i[uid provider])
  end

  def customer_details
    user_params = params.require(:user)
                        .permit(:first_name, :last_name, :email, :phone)
                        .as_json.map { |k, v| "#{k.to_s.titleize} : #{v}" }
                        .join(', ')
    [user_params, "Company : #{company_name}"].join(', ')
  end

  def company_name
    (params.fetch(:business, nil) || params.fetch(:agency, nil)).fetch(:name)
  end

  def credit_card_attrs
    {
      object: 'card',
      exp_month: params[:expiry].split('/').map(&:strip).first,
      exp_year: params[:expiry].split('/').map(&:strip).second,
      number: params[:number],
      address_city: params[:billing][:city],
      address_country: params[:billing][:country],
      address_line1: params[:billing][:address],
      address_line2: params[:billing][:address_2],
      address_state: params[:billing][:state],
      address_zip: params[:billing][:zip],
      cvc: params[:cvc],
      name: params[:billing][:first_name] + ' ' + params[:billing][:last_name]
    }
  end

  def via_omniauth
    @user =
      User.create(
        user_omniauth_params.merge!(role: 'company_admin',
                                    ownable: @business,
                                    password: Devise.friendly_token[0, 20])
      )
    sign_in_and_redirect @user
  end

  def user_present?
    redirect_to helpers.current_user_dashboard if current_user.present?
  end

  # Referrals disabled
  # def set_referrer
  #   return unless referrer
  #   referee = User.find_by(email: user_params[:email])
  #   return unless referee
  #   Referral.create(referrer_id: referrer.id, referee_id: referee.id)
  #   SignupMailer.new_referral_signup(user, referrer).deliver_later
  # end

  # def referrer
  #   return unless params[:ref]
  #   @_referrer ||= User.find_by(referral_code: params[:ref])
  # end

  def check_eligibility
    raise 'Disposable? email addresses are not allowed' if Freemail.disposable?(user_params[:email])
  rescue StandardError => e
    @msg = e.message
    @error = true
    respond_to do |format|
      format.html { render :signup_response }
      format.json { render json: { error: e.message } }
    end and return
  end
end
