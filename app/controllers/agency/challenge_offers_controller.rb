# frozen_string_literal: true
class Agency::ChallengeOffersController < Agency::BaseController
  include AgencyStripeManager

  def show; end

  def payment_details
    @customer = current_agency.stripe_customer
    if @customer && !@customer.deleted?
      @cards =
        @customer.sources[:data].select{|source| source[:object].eql?('card')}
    end
    @default_card = @customer&.default_source || 'add_card'
  end

  def create
    @customer = current_agency.stripe_customer

    if @customer.blank? || @customer.deleted?
      @customer = Stripe::Customer.create(
        email: current_user.email,
        description: customer_details
      )
    end

    if params[:selected_card].eql?('add_card')
      card = @customer.sources.create(source: credit_card_attrs)
      @customer.default_source = card.id
    else
      @customer.default_source = params[:selected_card]
    end

    @charge = Stripe::Charge.create({
      customer: @customer.id,
      amount: 499700,
      currency: 'usd',
      description: "Agency<#{current_agency.name}> : Challenge Offer"
    })

    @plan = Package.growth.plans.find_by(key: 'grow')
    @stripe_sub = Stripe::Subscription.create(
      customer: @customer.id,
      trial_period_days: 90,
      items: [{ plan: @plan.stripe_plan }]
    )

    AgencySignupPaymentService.process(
      onetime_charge_sub: nil,
      onetime_charge_plan: nil,
      charge: @charge,
      payment: @stripe_sub,
      plan: @plan,
      signup_link: nil,
      coupon: nil,
      user: current_user
    )

    AdminMailer.challenge_offer_mail(current_agency.id).deliver_later

    redirect_to agency_clients_path, notice: 'Your payment has been processed.'
  end

  private

  def customer_details
    cust_params = current_user.attributes.slice(
      'first_name', 'last_name', 'email', 'phone'
    ).map { |k, v| "#{k.to_s.titleize} : #{v}" }.join(', ')
    [cust_params, "Agency : #{current_agency.name}"].join(', ')
  end
end
