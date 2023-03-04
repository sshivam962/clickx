# frozen_string_literal: true

class SubscriptionScheduleCancelService
  def initialize(params)
    @subscription_schedule = params[:subscription_schedule]
    @agency = params[:agency]
    @active_subscription = params[:active_subscription]
  end

  def perform
    return unless @agency

    Stripe::SubscriptionSchedule.cancel(@subscription_schedule.stripe_id)
    update_active_subscription_end_period
  end

  def self.process(*args)
    new(*args).perform
  end

  def update_active_subscription_end_period
    Stripe::Subscription.update(
      @active_subscription.account_id,
      {
        cancel_at_period_end: false
      }
    )
  end
end
