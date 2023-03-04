class Agency::PackageSubscriptionsController < Agency::BaseController
  include AgencyStripeManager

  skip_before_action :agency_active_check, :active_agency?
  before_action :set_package, only: %i[create new upgrade change_plan load_plan]
  before_action :set_plan, only: %i[create new upgrade]
  before_action :set_quantity, only: %i[create new change_plan load_plan]
  before_action :ensure_package, only: :new
  before_action :set_customer, only: :create
  before_action :set_subscription_package, only: :invoices

  def create
    begin
      @invoices = []
      initiate_subscription_process
      result = subscribe_package
      checkout_addons if @addon_plans.present?
      process_payments(result)
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

  def create_client
    @business = current_agency.businesses.create(business_params)
    if params[:selected_business].eql?('add_from_leads')
      lead = ::Lead.find params[:selected_lead]
      lead.update(business_id: @business.id, status: 'customer')
    end
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

  def new
    @customer = current_agency.stripe_customer if current_agency.customer_id
    @businesses = current_agency.businesses
    if @customer && !@customer.deleted?
      @cards =
        @customer.sources[:data].select{|source| source[:object].eql?('card')}
    end
    @default_card = @customer&.default_source || 'add_card'
  end

  def new_card
    content =
      render_to_string partial: 'agency/package_subscriptions/shared/new_card'
    render json: {data: content, status: 200}
  end

  def new_business
    @lead = ::Lead.find_by(id: params[:lead_id])
    content =
      render_to_string(
        partial: 'agency/package_subscriptions/shared/new_business'
      )
    render json: {data: content, status: 200}
  end

  def success; end

  def index
    @package_subscriptions = current_agency.package_subscriptions
                                           .includes(:business, :agency)
                                           .where.not(metadata: nil)
                                           .order(:status)
                                           .group_by(&:package_type)
  end

  def invoices
    if @package_subscription.subscription?
      @invoices = Stripe::Invoice.list(
        { subscription: @package_subscription.metadata['id'] }
      )['data']
      content = render_to_string partial: 'agency/package_subscriptions/shared/invoices'
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

  def upgrade
    return unless @package&.key.eql?('agency_infrastructure')

    @active_subscription = current_agency.stripe_active_package
    PackageSubscriptionMailer.agency_package_upgrade_started(
      current_agency, @plan, @active_subscription
    ).deliver_later
    begin
      PackageUpgradeService.process(
        agency: current_agency,
        plan: @plan,
        active_subscription: @active_subscription
      )
    rescue Exception => e
      @error = e.message
    end
  end

  def change_plan
    @expedited_onboarding = params[:expedited_onboarding].eql?('true')
    @white_glove_service = params[:white_glove_service].eql?('true')
    @addons = Plan.where(id: params[:addons])
    @plan = fetch_plan_by_white_glove_service

    content =
      render_to_string(
        partial: 'agency/package_subscriptions/shared/plan_details',
        locals: {
          plan: @plan,
          package: @package,
          expedited_onboarding: @expedited_onboarding,
          white_glove_service: @white_glove_service,
          addons: @addons
        }
      )

    render json: {
      data: {
        content: content,
        form_action: agency_subscribe_package_path(package: @plan.package_type, plan: @plan.key)
      }, status: 200
    }
  end

  def load_plan
    @expedited_onboarding = params[:expedited_onboarding].eql?('true')
    @white_glove_service = params[:white_glove_service].eql?('true')
    @addons = Plan.where(id: params[:addons])

    @plan = @package.plans.find_by(key: params[:new_plan])

    content =
      render_to_string(
        partial: "agency/package_subscriptions/shared/plan_details",
        locals: {
          plan: @plan,
          package: @package,
          expedited_onboarding: @expedited_onboarding,
          white_glove_service: @white_glove_service,
          addons: @addons
        }
      )

    render json: {
      data: {
        content: content,
        form_action: agency_subscribe_package_path(package: @plan.package_type, plan: @plan.key)
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
        Package.find_by(key: params[:package])
      end
  end

  def set_plan
    return if @package.blank?

    @plan =
      if params[:package].eql?('custom')
        @package.plan
      else
        @package.plans.find_by(key: params[:plan])
      end
  end

  def fetch_plan_by_white_glove_service
    plan_key =
      if params[:white_glove_service].eql?('true')
        params[:plan] + '_with_white_glove_service'
      else
        params[:plan].gsub('_with_white_glove_service', '')
      end
    @package.plans.find_by(key: plan_key)
  end

  def subscribe_package
    raise 'Invalid Package' if @plan.blank?

    onetime_invoice =
      if @plan[:onetime_charge].present? && current_agency.onetime_charge?
        Stripe::InvoiceItem.create({
          amount: (@plan[:onetime_charge].to_f * 100).to_i,
          currency: 'usd',
          customer: @customer.id,
          description: "One-time Charge - #{@plan.name}"
        })
      end
    @invoices.push(onetime_invoice)

    implementation_invoice =
      if params[:expedited_onboarding]
        Stripe::InvoiceItem.create({
          amount: (@plan[:implementation_fee].to_f * 100).to_i,
          currency: 'usd',
          customer: @customer.id,
          description: "Expedited Onboarding Fee - #{@plan[:name]}"
        })
      end
    @invoices.push(implementation_invoice)
    payment =
      if @plan[:billing_category] == 'subscription'
        Stripe::Subscription.create(
          customer: @customer.id,
          plan: @plan[:stripe_plan]
        )
      else
        plan_amount =
          if @package.quantity_enabled?
            @plan.amount * @quantity
          else
            @plan[:amount]
          end
        Stripe::Charge.create({
          customer: @customer.id,
          amount: (plan_amount.to_f * 100).to_i,
          currency: 'usd',
          description: "Agency-#{current_agency.name} : #{@plan[:name]}"
        })
      end
    {
      payment: payment,
      implementation_invoice: implementation_invoice,
      onetime_invoice: onetime_invoice
    }
  end

  def ensure_business
    return unless @plan[:business_required]

    @business = current_agency.businesses.find_by(id: params[:business_id])
    raise 'Client not found.' unless @business
  end

  def ensure_subscription_not_exists
    if @plan[:billing_category] == 'subscription'
      existing_sub =
        if @plan[:business_required]
          # @business.package_subscriptions
          #          .find_by(plan_id: @plan[:stripe_plan])
        else
          # current_agency.package_subscriptions
          #               .find_by(plan_id: @plan[:stripe_plan])
        end
      raise 'Subscription already exists' if existing_sub
    end
  end

  def initiate_subscription_process
    ensure_business
    ensure_subscription_not_exists
    ensure_payment_method
    setup_addons
  end

  def business_params
    params.require(:business).permit(:name, :domain, :target_city, :locale)
  end

  def process_payments(result)
    PackageSubscriptionService.process(
      payment: result[:payment],
      plan: @plan,
      implementation_invoice: result[:invoice],
      onetime_invoice: result[:onetime_invoice],
      business: @business&.id,
      expedited_onboarding: params[:expedited_onboarding],
      addon_plans: @addon_plans,
      quantity: @quantity,
      funnel_platform: params[:funnel_platform],
      current_user: current_user
    )
  end

  def setup_addons
    @addon_plans = Plan.where(id: params[:addons])
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

  def set_redirect_path
    @redirect_path =
      if current_agency.agreement_signed?
        '/a/package_subscriptions/success'
      else
        '/a/sign_agreement'
      end
  end


  def ensure_package
    return if @package.present? && @plan.present?

    flash[:error] = "Package doesn't exist!"
    redirect_to agency_clients_path
  end

  def set_quantity
    @quantity = params[:quantity].to_i > 0 ? params[:quantity].to_i : 1
  end
end
