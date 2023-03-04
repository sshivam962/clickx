# frozen_string_literal: true

class Agency::SignupsController < ActionController::Base
  # include TylerSignupManager

  before_action :ensure_no_user_logged_in
  before_action :set_signup_link, only: %i[paid create]
  before_action :set_plan, only: %i[paid create]
  before_action :check_signup_link_expiry, only: %i[paid create]
  before_action :set_annual_plan, only: :paid
  before_action :set_referral_code, only: %i[free paid]
  before_action :set_coupon, only: %i[paid create check_coupon]

  layout 'signup'

  def free
    if @referral_code
      redirect_to agency_referral_signup_path(referral_code: @referral_code, tier: 'starter')
    end
  end

  def free_signup
    ActiveRecord::Base.transaction do
      raise 'Email ID already exists' if user_exists?

      @agency = Agency.new(agency_create_params)
      set_referrer if params[:referral_code].present?

      if @agency.valid?
        # set_stripe_customer
        # set_stripe_card
        save_agency
        set_default_agency_access

        SignupMailer.new_free_agency_signup({
          agency_id: @agency.id,
          user_id: @user.id
        }).deliver_later

        sign_in(@user)
        redirect_to after_sign_in_path_for(@user)
      else
        @validation_error = true
        raise @agency.errors.full_messages.to_sentence
      end
    end
  rescue StandardError => e
    @error = e
    ErrorNotify.signup_error(params.except(:card_token).as_json, @error.message).deliver_later
  end

  def tyler
    redirect_to agency_paid_path(tier: 'starter'), status: 301
  end

  def create
    ActiveRecord::Base.transaction do
      raise 'Email ID already exists' if user_exists?

      @agency = Agency.new(agency_create_params)
      set_referrer if params[:referral_code].present?

      if @agency.valid?
        if @plan.present?
          set_stripe_customer
          set_stripe_card
          save_agency
          set_default_agency_access
          process_payment
          AgencySignupPaymentService.process(
            onetime_charge_sub: @onetime_charge_sub,
            onetime_charge_plan: @onetime_charge_plan,
            charge: @charge,
            payment: @stripe_sub,
            plan: @plan,
            signup_link: @signup_link,
            coupon: @coupon,
            user: @user
          )
          if @signup_link.present? && !@signup_link.reusable_link?
            @signup_link.update(paid: true)
          end
        else
          save_agency
        end

        if @signup_link.blank? || @signup_link.trial?
          @magic_link = Magic::Link::MagicLink.new(email: @user.email)
          @magic_link.send_login_instructions
        end
      else
        @validation_error = true
        raise @agency.errors.full_messages.to_sentence
      end
    end
  rescue StandardError => e
    @error = e
    ErrorNotify.signup_error(params.except(:card_token).as_json, @error.message).deliver_later
  end

  def paid
    SignupLinkVisitedJob.perform_async(
      @signup_link&.id,
      request.remote_ip,
      request.referer,
      request.original_url,
      request.user_agent
    ) if @signup_link.present?
  end

  def check_coupon
    if @coupon
      total_price = params[:plan_price].to_i
      discount_msg, offer_msg =
        helpers.coupon_applied_info @coupon, total_price, false
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
    @plan = Package.growth.plans.find_by(key: plan_key)
  end

  def set_annual_plan
    return if @signup_link

    @annual_plan = Package.growth.plans.find_by(key: "annual_#{plan_key}")
  end

  def plan_key
    return @signup_link.plan_key if @signup_link.present?

    tier =
      if params[:tier].include?('pro')
        'grow'
      elsif params[:tier].include?('accelerate')
        'momentum'
      elsif params[:tier].include?('advanced')
        'rainmaker'
      else
        params[:tier]
      end

    if params[:interval].eql?('year')
      "annual_#{tier}"
    else
      tier
    end
  end

  def set_signup_link
    return if params[:tier].blank? || params[:tier].exclude?('-')

    plan_key = params[:tier].scan(Regexp.new(Agency::PLAN_KEYS.join('|'))).last
    signup_key = params[:tier].remove("#{plan_key}-")
    @signup_link = SignupLink.active.agency.find_by_obfuscated_id(signup_key)
    return if @signup_link.present?

    redirect_to 'https://www.clickx.io/agency-pricing'
  end

  def check_signup_link_expiry
    return if @signup_link.blank?
    return unless @signup_link.expired? || @signup_link.paid?

    redirect_to "https://www.clickx.io/success/expired-link/"
  end

  def set_referral_code
    @referral_code = params[:referral_code].presence
  end

  def user_exists?
    User.exists? email: user_params[:email]
  end

  def agency_params
    params.require(:agency).permit(:name, :address, :support_email)
  end

  def user_params
    # params.require(:user).permit(:first_name, :last_name, :email, :phone)
    {
      first_name: @signup_link&.first_name.presence || params[:user][:first_name],
      last_name: @signup_link&.last_name.presence || params[:user][:last_name],
      email: @signup_link&.email.presence || params[:user][:email],
      phone: params[:user][:phone],
      agency_super_admin: true
    }
  end

  def agency_create_params
    clients_limit = 25
    agency_params.merge!(
      clients_limit: clients_limit,
      keywords_limit: clients_limit * 100,
      competitors_limit: clients_limit * 10,
      signup_approved: @signup_link.blank? || @signup_link.trial?
    )
  end

  def set_referrer
    referrer = User.find_by(referral_code: params[:referral_code])
    return if referrer.blank?

    @agency.referrer = referrer
  end

  def set_stripe_customer
    @customer = Stripe::Customer.create(
      email: user_params[:email],
      description: customer_details,
      metadata: {
        lm_data: params[:lm_data]
      }
    )
  end

  def set_stripe_card
    @card = Stripe::Customer.create_source(
      @customer.id,
      { source: params[:card_token] },
    )
  end

  def process_payment
    if @signup_link.present? && @signup_link&.onetime_charge&.positive?
      if @signup_link.onetime_charge_duration?
        if @signup_link.down_payment?
          @charge = Stripe::Charge.create({
            amount: (@signup_link.down_payment.to_f * 100).to_i,
            currency: 'usd',
            customer: @customer.id,
            description: "New Agency <#{agency_params[:name]}> via Signup Link"
          })
          onetime_charge_product
          onetime_charge_plan
          @onetime_charge_sub = Stripe::Subscription.create(
            customer: @customer.id,
            plan: @onetime_charge_plan.id,
            trial_end: (DateTime.now + 1.months).to_time.to_i,
            cancel_at: ((DateTime.now + 1.months) + @signup_link.onetime_charge_duration.months).to_time.to_i
          )
        else
          if @signup_link.onetime_charge_duration == 1
            @charge = Stripe::Charge.create({
              amount: (@signup_link.onetime_charge.to_f * 100).to_i,
              currency: 'usd',
              customer: @customer.id,
              description: "New Agency <#{agency_params[:name]}> via Signup Link"
            })
          else
            onetime_charge_product
            onetime_charge_plan
            @onetime_charge_sub = Stripe::Subscription.create(
              customer: @customer.id,
              plan: @onetime_charge_plan.id,
              cancel_at: (DateTime.now + @signup_link.onetime_charge_duration.months).to_time.to_i
            )
          end
        end
      else
        if @signup_link.down_payment?
          @charge = Stripe::Charge.create({
            amount: (@signup_link.down_payment.to_f * 100).to_i,
            currency: 'usd',
            customer: @customer.id,
            description: "New Agency <#{agency_params[:name]}> via Signup Link"
          })
          onetime_charge_product
          onetime_charge_plan
          @onetime_charge_sub = Stripe::Subscription.create(
            customer: @customer.id,
            trial_end: (DateTime.now + 1.months).to_time.to_i,
            plan: @onetime_charge_plan.id
          )
        else
          onetime_charge_product
          onetime_charge_plan
          @onetime_charge_sub = Stripe::Subscription.create(
            customer: @customer.id,
            plan: @onetime_charge_plan.id
          )
        end
      end
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

  def onetime_charge_product
    @onetime_charge_product = Stripe::Product.create({name: 'Onboarding Onetime Charge', type:'service'})
  end

  def onetime_charge_plan
    @onetime_charge_plan = Stripe::Plan.create({
      amount: (@signup_link.onetime_charge.to_f * 100).to_i,
      currency: 'usd',
      interval: 'month',
      product: @onetime_charge_product.id,
    })
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
    [cust_params, "Agency : #{agency_name}"].join(', ')
  end

  def agency_name
    params.fetch(:agency, nil).fetch(:name)
  end

  def save_agency
    ActiveRecord::Base.transaction do
      @agency.customer_id = @customer.id if @customer.present?
      @agency.save!
    end
    @agency.create_billing_address(billing_address_params.merge!(
      first_name: user_params[:first_name],
      last_name: user_params[:last_name]
    ))
    @agency.reload

    if @signup_link.present?
      @user =
        if @signup_link.send_invite?
          User.invite!(
            user_params.merge!(
              role: 'agency_admin', ownable: @agency
            )
          )
        else
          @agency.users.create!(
            user_params.merge!(
              role: 'agency_admin', password: SecureRandom.hex(16)
            )
          )
        end
    else
      @user = User.invite!(
        user_params.merge!(
          role: 'agency_admin', ownable: @agency
        )
      )
    end

    CloseioJob.perform_later(@user)
  end

  def set_default_agency_access
    return if @plan.blank?

    @_features = {}
    @_access = {}
    @_default_settings = {
      enable_cold_email: true,
      coaching_calls_in_support_page: true,
      enabled_packages: %w[
        ala_carte facebook_ads generate_lead_strategy google_ads local_seo
        seo_services social_media web_dev_product
      ]
    }

    if @plan.amount >= 299
      @_features.merge!({
        white_labeled: true,
        payment_links_enabled: true,
        plans_enabled: true,
        support_prospecting_call: true,
        is_social_media_ad: true,
        value_hook: true,
        case_study_limited_access: true,
        portfolio_limited_access: true,
        coaching_calls_in_support_page: true,
      })

      @_default_settings.merge!({
        email_leads_count_limit: 1500,
      })

      @_access.merge!({
        course_ids: Course.agency.acadamics.ids,
        enabled_document_categories: Document::PLAN_299
      })
    end

    if @plan.amount >= 799
      @_features.merge!({
        case_study_enabled: true,
        portfolio_enabled: true,
      })

      @_default_settings.merge!({
        email_leads_count_limit: 5000,
      })

      @_access.merge!({
        course_ids: Course.where(title: Course::PLAN_799).ids,
        enabled_document_categories: Document::PLAN_799
      })
    end

    @_defaults = [@_features, @_access, @_default_settings].reduce(&:merge)
    @agency.update!(@_defaults)
  end

  def set_coupon
    coupon_code =
       @signup_link&.coupon? ? @signup_link.coupon_code : params[:coupon_code]
    return if coupon_code.blank?

    @coupon = Subscription::Coupon.active.find_by coupon_id: coupon_code
  end
end
