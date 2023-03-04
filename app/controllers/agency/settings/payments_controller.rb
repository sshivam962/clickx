class Agency::Settings::PaymentsController < Agency::BaseController
  include AgencyStripeManager
  before_action :set_plan, only: :create
  before_action :set_customer, only: :create

  def create
    begin
      ensure_payment_not_exists
      setup_payment_method
      @payment = create_charge
      PackageSubscriptionService.process(
        payment: @payment, plan: @plan,
        implementation_invoice: @onetime_invoice,
        current_user: current_user
      )
    rescue Exception => e
      @error = e.message
    end
  end

  private

  def set_plan
    @plan =
      Plan.find_by(package_type: 'agency_domain_management', key: 'basic_v2')
  end

  def create_charge
    raise 'Invalid Package' if @plan.blank?

    @onetime_invoice =
      Stripe::InvoiceItem.create({
        amount: (@plan.onetime_charge.to_f * 100).to_i,
        currency: 'usd',
        customer: @customer.id,
        description: "One-Time Charge - #{@plan[:name]}"
      })

    @payment =
      Stripe::Subscription.create(
        customer: @customer.id,
        plan: @plan.stripe_plan
      )
  end

  def ensure_payment_not_exists
    existing_payment =
      current_agency.package_subscriptions.find_by(plan_id: @plan[:stripe_plan])
    raise 'Subscription already exists' if existing_payment
  end
end
