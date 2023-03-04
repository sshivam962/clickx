# frozen_string_literal: true

module Subscription
  class Plan < ApplicationRecord
    include PlanHelpers
    acts_as_paranoid

    enum plan_type: %i[_ client agency]

    DAY_COUNT = { 'day' => 1..365, 'week' => 1..52,
                  'month' => 1..12, 'year' => 1..1 }.freeze
    has_many :businesses, foreign_key: :custom_plan_id
    validates :name, :plan_id, :currency, :interval, presence: true
    validates :plan_id, uniqueness: true
    validates :interval,
              inclusion: { in: DAY_COUNT.keys,
                           message: '%{value} is not a valid interval',
                           if: -> { interval.present? } }
    validates :currency,
              inclusion: { in: %w[usd],
                           message: '%{value} is not a valid currency',
                           if: -> { currency.present? } }
    validates :amount, numericality: { greater_than_or_equal_to: 0 }
    validates :interval_count,
              numericality: { greater_than: 0 },
              inclusion: { in: ->(obj) { DAY_COUNT[obj.interval] },
                           message: 'cannot be greater than an year',
                           if: (lambda do
                                  interval_count.positive? &&
                                    DAY_COUNT.keys.include?(interval)
                                end) }
    scope :only_private, -> { where(public: false) }
    scope :only_public, -> { where(public: true) }

    def self.plan_columns
      %i[name plan_id currency interval amount interval_count
         statement_descriptor trial_period_days]
    end

    def self.find_plan(plan_id)
      find_by(plan_id: plan_id) || find_by(plan_id: ENV['STRIPE_DEFAULT_PLAN'])
    end
  end
end
