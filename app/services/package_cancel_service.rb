# frozen_string_literal: true

class PackageCancelService
  def initialize(params)
    @package_subscription = params[:package_subscription]
    @agency = params[:agency]
    @cancel = params[:cancel]
  end

  def self.process(*args)
    new(*args).perform
  end

  def perform
    return unless @agency

    stripe_sub =
      Stripe::Subscription.retrieve(@package_subscription.account_id)
    @data =
      Stripe::Subscription.update(
        @package_subscription.account_id,
        { cancel_at_period_end: @cancel }
      ).to_h
    ActiveRecord::Base.transaction do
      @package_subscription.update(billing_attributes)
    end
  end

  def billing_attributes
    {
      status: @data[:status],
      metadata: @data,
      cancel_at: time_at(@data[:cancel_at]),
      canceled_at: time_at(@data[:canceled_at])
    }
  end

  def time_at value
    return nil if value.blank?

    Time.at(value)
  end
end
