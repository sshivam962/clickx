# frozen_string_literal: true

class PaymentLinkSubscribeService
  def initialize(params)
    @payment_link = params[:payment_link]
    @agency = @payment_link.agency
    @user_info = @payment_link.user_info
    @plan = @payment_link.plan

    @card_token = params[:card_token]
    @stripe_customer = params[:stripe_customer]

    @stripe_api_key = @agency.stripe_credential.secret_key
  end

  def perform
    return unless @agency

    subscribe_plan
    PaymentLinkSubscription.create(subscription_attributes)
    @payment_link.update(status: :paid)
    send_notifications
  end

  def send_notifications
    PaymentLinkMailer.plan_subscribed_mail({
      payment_link_id: @payment_link.id
    }).deliver_later
  end

  def self.process(*args)
    new(*args).perform
  end

  def subscription_attributes
    {
      account_id: @payment.id,
      amount: @plan.amount,
      customer: @stripe_customer.id,
      interval: @plan.interval,
      status: @payment.status,
      billing_category: @plan.billing_category,
      metadata: @payment.to_h,
      implementation_invoice_id: @invoice&.id,
      agency: @agency,
      plan: @plan
    }
  end

  def subscribe_plan
    raise 'Invalid Plan' if @plan.blank?

    if @plan.pay_with_implementation_fee
      @invoice =
        Stripe::InvoiceItem.create(
          {
            amount: (@plan.implementation_fee.to_f * 100).to_i,
            currency: 'usd',
            customer: @stripe_customer.id,
            description: "Implementation Fee - #{@agency.name} : #{@user_info[:name]}"
          },
          api_key: @stripe_api_key
        )
    end

    @payment =
      if @plan.subscription?
        Stripe::Subscription.create(
          {
            customer: @stripe_customer.id,
            plan: @plan.stripe_plan_id
          },
          api_key: @stripe_api_key
        )
      else
        Stripe::Charge.create(
          {
            customer: @stripe_customer.id,
            amount: (@plan.amount.to_f * 100).to_i,
            currency: 'usd',
            description: "#{@agency.name} : #{@user_info[:name]} - #{@plan.description_line_1}, #{@plan.description_line_2}"
          },
          api_key: @stripe_api_key
        )
      end
  end
end
