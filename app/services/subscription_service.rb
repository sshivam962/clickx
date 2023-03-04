# frozen_string_literal: true

class SubscriptionService
  def initialize(params)
    @data = params[:subscription].to_h
    @plan_data = @data[:plan].to_h
  end

  def perform
    @owner = Business.find_by(customer_id: @data[:customer])
    return unless @owner

    subscription = @owner.subscription_accounts
                         .find_or_initialize_by(account_id: @data[:id])

    sub_attributes = @data.slice(*Subscription::Account.account_columns)
    plan_columns = %i[currency interval interval_count trial_period_days]
    plan_attributes = @plan_data.slice(*plan_columns)

    sub_attributes[:plan_id] = @plan_data[:id]
    sub_attributes[:plan_name] = @plan_data[:name]
    subscription.assign_attributes sub_attributes
    subscription.assign_attributes plan_attributes

    Subscription::Account.datetime_columns.each do |column|
      subscription.send("#{column}=", @data[column] && Time.at(@data[column]))
    end

    subscription.save!

    subscription
  end

  def self.process(*args)
    new(*args).perform
  end
end
