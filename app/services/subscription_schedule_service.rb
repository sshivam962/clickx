# frozen_string_literal: true

class SubscriptionScheduleService
  def initialize(params)
    @data = params[:data]
    @event_type = params[:event_type]
    @agency = Agency.find_by(customer_id: @data[:customer])
  end

  def perform
    return unless @agency

    @schedule = fetch_schedule
    @schedule.update(schedule_attributes)
    return unless @event_type.eql?('released')

    subscribe_package
  end

  def subscribe_package
    @subscription = Stripe::Subscription.retrieve(@data[:subscription])
    @agency.active_package.update(
      status: 'cancelled'
    )
    @agency.package_subscriptions.create(subscription_attributes)
  end

  def self.process(*args)
    new(*args).perform
  end

  def subscription_attributes
    {
      plan_id: @subscription[:plan][:id],
      amount: @subscription[:plan][:amount],
      customer: @subscription[:customer],
      status: @subscription[:status],
      billing_category: @subscription[:object],
      package_name: @subscription[:plan][:id],
      metadata: @subscription,
      billing_type: 'stripe',
      package_type: 'agency_infrastructure'
    }
  end

  def fetch_schedule
    @agency.subscription_schedules.find_or_initialize_by(stripe_id: @data[:id])
  end

  def schedule_attributes
    {
      status: @data[:status],
      metadata: @data
    }
  end
end
