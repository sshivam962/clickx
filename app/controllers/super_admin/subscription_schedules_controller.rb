# frozen_string_literal: true

class SuperAdmin::SubscriptionSchedulesController < ApplicationController
  before_action :set_subscription_schedule
  before_action :set_agency
  before_action :set_active_subscription

  def cancel
    SubscriptionScheduleCancelService.process(
      subscription_schedule: @subscription_schedule,
      agency: @agency,
      active_subscription: @active_subscription
    )
    @subscription_schedule.update(status: 'canceled')
  rescue StandardError => e
    @error =  e.message
  end

  private

  def set_subscription_schedule
    @subscription_schedule = SubscriptionSchedule.find params[:id]
  end

  def set_agency
    @agency = @subscription_schedule.agency
  end

  def set_active_subscription
    @active_subscription = @agency.stripe_active_package
  end
end

