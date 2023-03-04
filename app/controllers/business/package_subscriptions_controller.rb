class Business::PackageSubscriptionsController < Business::BaseController
  include BusinessStripeManager

  before_action :check_if_clickx_client?
  before_action :set_package, only: %i[create new upgrade]
  before_action :set_plan, only: %i[create new upgrade]
  before_action :set_current_subscription, only: :upgrade
  before_action :set_customer, only: :create
  before_action :set_subscription_package, only: :invoices

  def create
    begin
      initiate_subscription_process
      result = subscribe_package
      BusinessPackageSubscriptionService.process(
        payment: result[:payment],
        plan: @plan,
        invoice: result[:invoice],
        business: current_business&.id,
        expedited_onboarding: expedited_onboarding?
      )
      set_redirect_path
    rescue Exception => e
      @error = e.message
    end
  end

  def new
    @customer = current_business.stripe_customer
    if @customer && !@customer.deleted?
      @cards =
        @customer.sources[:data].select{|source| source[:object].eql?('card')}
    end
    @default_card = @customer&.default_source || 'add_card'
  end

  def new_card
    content =
      render_to_string partial: 'business/package_subscriptions/shared/new_card'
    render json: {data: content, status: 200}
  end

  def create_card
    begin
      set_customer
      @card = Stripe::Customer.create_source(
        @customer.id,
        { source: params[:token] },
      )
    rescue Exception => e
      @error = e.message
    end
  end

  def success; end

  def index
    @package_subscriptions = current_business.package_subscriptions
                                             .includes(:business, :agency)
                                             .where.not(metadata: nil)
                                             .group_by(&:package_type)
  end

  def invoices
    if @package_subscription.subscription?
      @invoices = Stripe::Invoice.list(
        { subscription: @package_subscription.metadata['id'] }
      )['data']
      content = render_to_string partial: 'business/package_subscriptions/shared/invoices'
    else
      content = Stripe::Charge.retrieve(@package_subscription.metadata['id'])
                              .receipt_url
    end
    render json: {
      data: {
        content: content,
        billing_category: @package_subscription.billing_category
      }, status: 200
    }
  end

  private

  def set_subscription_package
    @package_subscription = PackageSubscription.find(params[:id])
  end


  def set_package
    @package =
      if params[:package].eql?('custom')
        CustomPackage.includes(:business).find_by(package_name: params[:plan])
      else
        Internal::Package.find_by(key: params[:package])
      end
  end

  def set_plan
    @plan =
      if params[:package].eql?('custom')
        @package.plan
      else
        @package.plans.find_by(key: params[:plan])
      end
  end

  def subscribe_package
    raise 'Invalid Package' if @plan.blank?

    invoice =
      if expedited_onboarding?
        Stripe::InvoiceItem.create({
          amount: (@plan[:implementation_fee].to_f * 100).to_i,
          currency: 'usd',
          customer: @customer.id,
          description: "Expedited Onboarding Fee - #{@plan[:product_name]}"
        })
      end
    payment =
      if @plan[:billing_category] == 'subscription'
        Stripe::Subscription.create(
          customer: @customer.id,
          plan: @plan[:stripe_plan]
        )
      else
        Stripe::Charge.create({
          customer: @customer.id,
          amount: (@plan[:amount].to_f * 100).to_i,
          currency: 'usd',
          description: "Agency-#{current_agency.name} : #{@plan[:name]}"
        })
      end
    { payment: payment, error: nil , invoice: invoice}
  end

  def ensure_business
    raise 'Client not found.' unless current_business
  end

  def ensure_subscription_not_exists
    if @plan[:billing_category] == 'subscription'
      existing_sub =
        current_business.package_subscriptions.find_by(
          plan_id: @plan[:stripe_plan]
        )
      raise 'Subscription already exists' if existing_sub
    end
  end

  def initiate_subscription_process
    ensure_business
    ensure_subscription_not_exists
    ensure_payment_method
  end

  def business_params
    params.require(:business).permit(:name, :domain, :target_city, :locale)
  end

  def set_current_subscription
    @current_subscription =
      current_business.active_package_subscriptions.stripe.find_by(
        package_type: @plan[:package_type]
      )
  end

  def expedited_onboarding?
    @plan[:implementation_fee].present?
  end

  def agreement_not_signed?
    !current_business.agreement_signed? &&
    current_user.normal? &&
    current_business.clickx?
  end

  def set_redirect_path
    @redirect_path =
      if agreement_not_signed?
        '/b/sign_agreement'
      else
        '/b/package_subscriptions/success'
      end
  end
end
