# frozen_string_literal: true

module PlanHelpers
  extend ActiveSupport::Concern

  def trial?
    trial_period_days&.positive?
  end

  def amount_dollars
    format('%.2f', (amount / 100.0))
  end

  def price_text
    interval_text =
      if interval_count == 1
        "per #{interval}"
      elsif (interval == 'month' && interval_count == 12) ||
            (interval == 'week' && interval_count == 52) ||
            (interval == 'day' && interval_count == 365)
        'per year'
      elsif interval == 'week' && (interval_count % 13).zero?
        "every #{(interval_count / 13) * 3} months"
      else
        "every #{interval_count} #{interval.pluralize(interval_count)}"
      end
    "$#{amount_dollars} #{interval_text}"
  rescue StandardError
    '$0 per month'
  end

  def as_json(options = {})
    super.merge(price_text: price_text)
  end
end
