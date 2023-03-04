# frozen_string_literal: true

module Subscription
  class Coupon < ApplicationRecord
    acts_as_paranoid

    validates :coupon_id, presence: true
    validates :duration,
              presence: true,
              inclusion: { in: %w[forever once repeating],
                           message: '%{value} is not a valid duration',
                           if: -> { duration.present? } }
    validates :amount_off,
              presence: true, if: -> { percent_off.blank? },
              numericality: { greater_than: 0,
                              if: -> { amount_off.present? } }
    validates :currency,
              presence: true, if: -> { percent_off.blank? },
              inclusion: { in: %w[usd],
                           message: '%{value} is not a valid currency',
                           if: -> { currency.present? } }
    validates :duration_in_months,
              presence: true, if: -> { duration == 'repeating' },
              numericality: { greater_than: 0,
                              if: -> { duration_in_months.present? } }
    validates :max_redemptions,
              numericality: { greater_than: 0,
                              if: -> { max_redemptions.present? } }
    validates :percent_off,
              presence: true, if: -> { amount_off.blank? },
              inclusion: { in: 1..100,
                           message: '%{value} is not a valid percent',
                           if: -> { percent_off.present? } }

    scope :active, (lambda do
      where('redeem_by > ? OR redeem_by IS NULL', Time.current)
    end)

    def self.coupon_columns
      %i[coupon_id duration amount_off currency duration_in_months max_redemptions percent_off redeem_by]
    end
  end
end
