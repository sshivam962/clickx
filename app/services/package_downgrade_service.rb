# frozen_string_literal: true

class PackageDowngradeService
  def initialize(params)
    @agency = params[:agency]
    @plan = Plan.find(params[:plan_id])
    @current_subscription = params[:active_subscription]
  end

  def self.process(*args)
    new(*args).perform
  end

  def perform
    return unless @agency

    @subscription = update_current_subscription_end_period
    @subscription_schedule = schedule_subscription
    PackageSubscriptionMailer.agency_package_downgraded(
      @agency, @subscription_schedule, @current_subscription
    ).deliver_later
    @subscription_schedule
  end

  def schedule_subscription
    @schedule =
      Stripe::SubscriptionSchedule.create({
        customer: @subscription[:customer],
        start_date: @subscription[:current_period_end],
        end_behavior: 'release',
        phases: [
          {
            plans: [
              { plan: @plan.stripe_plan },
            ]
          },
        ],
      })
    @agency.subscription_schedules.create(schedule_attributes)
  end

  def update_current_subscription_end_period
    Stripe::Subscription.update(
      @current_subscription.account_id,
      {
        cancel_at_period_end: true
      }
    ).to_h
  end

  def schedule_attributes
    {
      stripe_id: @schedule[:id],
      status: @schedule[:status],
      stripe_plan: @plan[:stripe_plan],
      start_at: Time.at(@subscription[:current_period_end]),
      metadata: @schedule
    }
  end
end
