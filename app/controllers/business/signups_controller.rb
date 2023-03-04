# frozen_string_literal: true

class Business::SignupsController < ActionController::Base
  before_action :ensure_no_user_logged_in
  before_action :set_signup_link, only: %i[paid create]
  before_action :set_plan, only: %i[paid create]
  before_action :check_signup_link_expiry, only: %i[paid create]
  before_action :set_coupon, only: %i[paid create check_coupon]

  layout 'signup'

  def free; end

  def create
    ActiveRecord::Base.transaction do
      raise 'Email ID already exists' if user_exists?

      @business = Business.new(business_create_params)
      if @business.valid?
        set_stripe_customer
        set_stripe_card
        save_business
        if @plan.present?
          process_payment
        end
        ClientSignupPaymentService.process(
          charge: @charge,
          payment: @stripe_sub,
          plan: @plan,
          business: @business.id,
          signup_link: @signup_link,
          coupon: @coupon,
          user: @user
        ) if @plan.present?
      else
        raise @business.errors.full_messages.to_sentence
      end
    end
  rescue StandardError => e
    @error = e
    ErrorNotify.signup_error(params.except(:card_token).as_json, @error.message).deliver_later
  end

  def paid; end

  def check_coupon
    if @coupon
      total_price = params[:plan_price].to_i
      discount_msg, offer_msg =
        helpers.coupon_applied_info(@coupon, total_price, false)
      discount = helpers.discount_by_coupon(@coupon, total_price, false)
      render(
        json: {
          code: 200,
          message: discount_msg,
          offer_msg: offer_msg,
          discount: discount
        }
      )
    else
      render json: { code: 404, message: 'Promo Code Not Found' }
    end
  end

  private

  def ensure_no_user_logged_in
    redirect_to root_path if current_user.present?
  end

  def set_plan
    @plan = Internal::Package.business_signup.plans.find_by(key: plan_key)
  end

  def plan_key
    return @signup_link.plan_key if @signup_link.present?

    return params[:tier]
  end

  def set_signup_link
    return if params[:tier].blank? || params[:tier].exclude?('-')

    plan_key = params[:tier].scan(/starter|pro|advanced/).last
    signup_key = params[:tier].remove("#{plan_key}-")
    @signup_link = SignupLink.active.business.find_by_obfuscated_id(signup_key)
    return if @signup_link.present?

    redirect_to business_paid_path(tier: plan_key)
  end

  def check_signup_link_expiry
    return if @signup_link.blank?
    return unless @signup_link.expired?

    flash[:notice] = 'Signup Link Expired'
    redirect_to business_paid_path(tier: @plan.key)
  end

  def user_exists?
    User.exists? email: user_params[:email]
  end

  def business_params
    params.require(:business).permit(:name, :domain, :target_city)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone)
  end

  def business_create_params
    business_params.merge!(
      agency: Agency.clickx,
      seo_service: true,
      contents_service: true,
      backlink_service: true,
      label_list: ['Software'],
      trial_service: false
    )
  end

  def set_stripe_customer
    @customer = Stripe::Customer.create(
      email: user_params[:email],
      description: customer_details
    )
  end

  def set_stripe_card
    @card = Stripe::Customer.create_source(
      @customer.id,
      { source: params[:card_token] },
    )
  end

  def process_payment
    if @signup_link.present?
      @charge = Stripe::Charge.create({
        amount: (@signup_link.onetime_charge.to_f * 100).to_i,
        currency: 'usd',
        customer: @customer.id,
        description: "New Business <#{business_params[:name]}> via Signup Link"
      })
    end
    if @signup_link&.trial?
      @stripe_sub = Stripe::Subscription.create(
        customer: @customer.id,
        trial_period_days: @signup_link.trial_period_days,
        items: [{ plan: @plan.stripe_plan }]
      )
    elsif @signup_link&.coupon?
      @stripe_sub = Stripe::Subscription.create(
        customer: @customer.id,
        coupon: @coupon&.coupon_id,
        items: [{ plan: @plan.stripe_plan }]
      )
    else
      if @coupon.present?
        @stripe_sub = Stripe::Subscription.create(
          customer: @customer.id,
          coupon: @coupon&.coupon_id,
          items: [{ plan: @plan.stripe_plan }]
        )
      else
        @stripe_sub = Stripe::Subscription.create(
          customer: @customer.id,
          items: [{ plan: @plan.stripe_plan }]
        )
      end
    end
  end

  def billing_address_params
    params.require(:billing).permit(
      :address_line_1, :address_line_2, :city, :country, :zip, :state
    )
  end

  def customer_details
    cust_params = params.require(:user)
                        .permit(:first_name, :last_name, :email, :phone)
                        .as_json.map { |k, v| "#{k.to_s.titleize} : #{v}" }
                        .join(', ')
    [
      cust_params,
      "Business : #{business_name}"
    ].select(&:present?).join(', ')
  end

  def business_name
    params.fetch(:business, nil).fetch(:name)
  end

  def save_business
    ActiveRecord::Base.transaction do
      @business.customer_id = @customer.id if @customer.present?
      @business.save!
    end
    @business.create_billing_address(billing_address_params.merge!(
      first_name: user_params[:first_name],
      last_name: user_params[:last_name]
    ))
    @user =
      User.invite!(
        user_params.merge!(role: 'company_admin', ownable: @business)
      )
    CloseioJob.perform_later(@user)
    sent_onboarding_client_mails if @plan.present?
  end

  def sent_onboarding_client_mails
    business_info = business_params.as_json
    user_info = user_params.as_json

    SignupMailer.welcome_box(
      business_info, user_info, @plan.key.titleize
    ).deliver_later

    SignupMailer.new_payment(
      business_info, user_info, @plan.key.titleize, @plan.amount * 100
    ).deliver_later

    SignupMailer.new_payment_recieved_sms(
      business_info, user_info, @plan.key.titleize, @plan.amount * 100
    ).deliver_later
  end

  def set_coupon
    coupon_code = @signup_link&.coupon_code || params[:coupon_code]
    @coupon = Subscription::Coupon.active.find_by coupon_id: coupon_code
  end
end
