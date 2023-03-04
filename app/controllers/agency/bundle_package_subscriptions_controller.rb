class Agency::BundlePackageSubscriptionsController < Agency::BaseController
  include AgencyStripeManager

  skip_before_action :agency_active_check, :active_agency?
  before_action :set_package, only: %i[create new]
  before_action :set_customer, only: :create

  def create
    begin
      @invoices = []
      @subscriptions = []
      @charges = []
      initiate_subscription_process
      subscribe_package
      checkout_addons if @addon_plans.present?
      process_payments
      send_admin_notifications
      set_redirect_path
    rescue Exception => e
      @invoices.compact.each do |invoice|
        Stripe::InvoiceItem.delete(invoice[:id])
      end
      @error = e.message
    end
    respond_to do |format|
      format.js
    end
  end

  def new
    @customer = current_agency.stripe_customer if current_agency.customer_id
    @businesses = current_agency.businesses
    if @customer && !@customer.deleted?
      @cards =
        @customer.sources[:data].select{|source| source[:object].eql?('card')}
    end
    @default_card = @customer&.default_source || 'add_card'
  end

  private


  def set_package
    @package =
      BundlePackage.includes(:bundle_plans)
                   .where(bundle_plans: {white_glove_service: false})
                   .find_by(key: params[:package])
  end

  def subscribe_package
    raise 'Invalid Package' if @package.blank?

    expedited_onboarding = params[:expedited_onboarding]
    expedited_invoice =
      if params[:expedited_onboarding]
        Stripe::InvoiceItem.create({
          amount: (@package.expedited_onboarding_fee.to_f * 100).to_i,
          currency: 'usd',
          customer: @customer.id,
          description: "Expedited Onboarding Fee - #{@package.name}"
        })
      end
    @invoices.push(expedited_invoice)

    @package.bundle_plans.each do |plan|
      onetime_invoice =
        if plan.onetime_charge.present?
          Stripe::InvoiceItem.create({
            amount: (plan.onetime_charge.to_f * 100).to_i,
            currency: 'usd',
            customer: @customer.id,
            description: "One-time Charge - #{plan.product_name}"
          })
        end
      @invoices.push(onetime_invoice)

      subscription =
        if plan.subscription?
          Stripe::Subscription.create(
            customer: @customer.id,
            plan: plan.stripe_plan
          )
        end
      @subscriptions.push(subscription)

      charge =
        if plan.charge?
          Stripe::Charge.create({
            customer: @customer.id,
            amount: (plan.amount.to_f * 100).to_i,
            currency: 'usd',
            description: "Agency<#{current_agency.name}> : #{plan.product_name}"
          })
        end
      @charges.push(charge)
    end

    if params[:white_glove_service]
      plan = @package.white_glove_plan
      white_glove_payment =
        Stripe::Subscription.create(
          customer: @customer.id,
          plan: plan[:stripe_plan]
        )
      @subscriptions.push(white_glove_payment)
    end
  end

  def process_payments
    BundlePackageSubscriptionService.process(
      agency: current_agency,
      package: @package,
      business: @business,
      subscriptions: @subscriptions,
      charges: @charges,
      invoices: @invoices,
      expedited_onboarding: params[:expedited_onboarding],
      white_glove_service: params[:white_glove_service],
      block_email: true,
      funnel_platform: params[:funnel_platform],
      current_user: current_user,
      addon_plans: @addon_plans
    )
  end

  def ensure_business
    @business = current_agency.businesses.find_by(id: params[:business_id])
    raise 'Client not found.' unless @business
  end

  def initiate_subscription_process
    ensure_business
    ensure_payment_method
    setup_addons
  end

  def business_params
    params.require(:business).permit(:name, :domain, :target_city, :locale)
  end

  def set_redirect_path
    @redirect_path =
      if current_agency.agreement_signed?
        '/a/package_subscriptions/success'
      else
        '/a/sign_agreement'
      end
  end

  def send_admin_notifications
    BundlePackageSubscriptionMailer.client_package_subscribed_mail(
      notification_params
    ).deliver_later

    BundlePackageSubscriptionMailer.client_package_subscribed_sms(
      notification_params
    ).deliver_later
  end

  def notification_params
    {
      business: @business,
      package: @package,
      addon_plans: @addon_plans.pluck(:id),
      expedited_onboarding: params[:expedited_onboarding],
      white_glove_service: params[:white_glove_service]
    }
  end

  def checkout_addons
    @addon_plans.each do |plan|
      implementation_invoice =
        if plan.implementation_fee.present?
          Stripe::InvoiceItem.create({
            amount: (plan.implementation_fee.to_f * 100).to_i,
            currency: 'usd',
            customer: @customer.id,
            description: "Implementation Fee - #{plan.product_name}"
          })
        end
      payment =
        if plan.subscription?
          Stripe::Subscription.create(
            customer: @customer.id,
            plan: plan.stripe_plan
          )
        else
          Stripe::Charge.create({
            customer: @customer.id,
            amount: (plan.amount.to_f * 100).to_i,
            currency: 'usd',
            description: "Agency-#{current_agency.name} : #{plan.product_name}"
          })
        end
      PackageSubscriptionService.process(
        payment: payment,
        plan: plan,
        implementation_invoice: implementation_invoice,
        block_email: true
      )
    end
  end

  def setup_addons
    @addon_plans = Plan.where(id: params[:addons])
  end
end
