# frozen_string_literal: true

class AdminPaymentLinkSubscribeService
  def initialize(params)
    @payment_link = params[:payment_link]
    @user_info = @payment_link.user_info
    @plan = @payment_link.admin_plan
    @card_token = params[:card_token]
    @stripe_customer = params[:stripe_customer]
  end

  def perform
    subscribe_plan
    AdminPaymentLinkSubscription.create(subscription_attributes)
    # @payment_link.update(status: :paid)
    send_notifications
  end

  def send_notifications
    AdminPaymentLinkMailer.plan_subscribed_mail({
      payment_link_id: @payment_link.id
    }).deliver_later

    AdminPaymentLinkMailer.plan_subscribed_sms({
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
      admin_plan: @plan
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
            description: "Implementation Fee : #{@user_info[:name]}"
          }
        )
    end

    @payment =
      if @plan.subscription?
        Stripe::Subscription.create(
          {
            customer: @stripe_customer.id,
            plan: @plan.stripe_plan_id
          }
        )
      else
        Stripe::Charge.create(
          {
            customer: @stripe_customer.id,
            amount: (@plan.amount.to_f * 100).to_i,
            currency: 'usd',
            description: "#{@user_info[:name]} - #{@plan.description_line_1}, #{@plan.description_line_2}"
          }
        )
      end
  end
end
