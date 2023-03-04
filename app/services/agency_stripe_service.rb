# frozen_string_literal: true

class AgencyStripeService
  def initialize(params)
    @data = params[:data]
    @event_type = params[:event_type]
    @agency = Agency.find_by(customer_id: @data[:customer])
    @plan = Plan.find_by(stripe_plan: @data[:plan][:id])
    @package = @plan&.package
  end

  def perform
    return unless @agency
    return unless @package&.agency_infrastructure?

    ActiveRecord::Base.transaction do
      sync_package
    end
  end

  def sync_package
    find_or_initialize_subscription
    @subscription&.update(subscription_attributes)
  end

  def self.process(*args)
    new(*args).perform
  end

  def subscription_attributes
    {
      plan_id: @data[:plan][:id],
      amount: @data[:plan][:amount] / 100,
      customer: @data[:customer],
      status: @data[:status],
      billing_category: @data[:object],
      package_name: @data[:plan][:id],
      metadata: @data,
      cancel_at: time_at(@data[:cancel_at]),
      canceled_at: time_at(@data[:canceled_at])
    }
  end

  def find_or_initialize_subscription
    @subscription = @agency.package_subscriptions.active.stripe
                           .find_by(account_id: @data[:id])

    return if @subscription.present?

    @subscription =
      @agency.package_subscriptions.new(
        account_id: @data[:id],
        amount: @data[:plan][:amount].to_f/100,
        billing_type: 'stripe',
        package_id: @package.id,
        package_class: @package.class.name,
        recipient_type: 'agency',
        quantity: 1,
        package_type: @package.key
      )
  end

  private

  def time_at value
    return nil if value.blank?

    Time.at(value)
  end
end
