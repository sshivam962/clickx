# frozen_string_literal: true

class PackageUpgradeService
  def initialize(params)
    @agency = params[:agency]
    @plan = params[:plan]
    @package = @plan.package
    @current_subscription = params[:active_subscription]
  end

  def perform
    return unless @agency

    @current_subscription.update(status: 'canceled')
    stripe_sub =
      Stripe::Subscription.retrieve(@current_subscription.account_id)
    @data =
      Stripe::Subscription.update(
        @current_subscription.account_id,
        {
          cancel_at_period_end: false,
          proration_behavior: 'always_invoice',
          items: [
            {
              id: stripe_sub.items.data[0].id,
              plan: @plan.stripe_plan
            }
          ]
        }
      )

    ActiveRecord::Base.transaction do
      @new_subscription =
        @agency.package_subscriptions.new(
          account_id: @data[:id], package_type: @plan[:package_type]
        )
      @new_subscription.update(billing_attributes)
    end
    sent_notifications
  end

  def sent_notifications
    PackageSubscriptionMailer.agency_package_upgraded(
      @agency, @new_subscription, @current_subscription
    ).deliver_later
    PackageSubscriptionMailer.agency_package_upgraded_sms(
      @agency, @new_subscription, @current_subscription
    ).deliver_later
  end

  def self.process(*args)
    new(*args).perform
  end

  def billing_attributes
    {
      plan_id: @plan[:stripe_plan],
      amount: @plan[:amount],
      customer: @data[:customer],
      status: @data[:status],
      billing_category: @plan[:billing_category],
      package_name: @plan[:package_name],
      metadata: @data,
      billing_type: 'stripe',
      package_id: @package.id,
      package_class: @package.class.name,
      recipient_type: 'agency',
      quantity: 1
    }
  end
end

