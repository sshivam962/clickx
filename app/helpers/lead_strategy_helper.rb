# frozen_string_literal: true

module LeadStrategyHelper
  def strategy_money_color key
    case key.split('_').last
    when 'starter'
      '#00bcd4'
    when 'pro'
      '#bad531'
    when 'advanced'
      '#f8b018'
    end
  end
end
