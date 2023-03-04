# frozen_string_literal: true

module Subscription
  class Account < ApplicationRecord
    include PlanHelpers

    validates :accountable_id, :accountable_type, :account_id, presence: true

    belongs_to :accountable, polymorphic: true

    enum status: %i[trialing active past_due canceled unpaid]
    enum billing: %i[charge_automatically send_invoice]

    def self.account_columns
      %i[cancel_at_period_end status billing]
    end

    def self.datetime_columns
      %i[current_period_start current_period_end canceled_at
         ended_at trial_start trial_end]
    end

    def next_period_start
      (current_period_end + 1.day)
        .strftime("%b #{(current_period_end + 1.day).day.ordinalize} %Y")
    end
  end
end
