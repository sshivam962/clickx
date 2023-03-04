# frozen_string_literal: true

module AgencyAccessHelpers
  extend ActiveSupport::Concern

  PLAN_KEYS = %w[
    starter
    pro
    advanced
    accelerate
    grow
    momentum
    rainmaker
    scale_dwy
    scale_dfy
  ]

  def growth_plan_key
    return unless growth_subscriptions.exists?

    package_name = growth_subscriptions.last.package_name.scan(Regexp.new(PLAN_KEYS.join('|'))).last
    if growth_subscriptions.stripe.exists?
      case package_name
      when 'starter' then 'start'
      when 'pro', 'grow' then 'grow'
      when 'accelerate', 'momentum' then 'momentum'
      when 'advanced', 'rainmaker' then 'rainmaker'
      else
        package_name
      end
    elsif labels.include?('DFYElite')
      'Free'
    else
      case package_name
      when 'starter' then 'start'
      when 'pro', 'grow' then 'grow'
      when 'accelerate' then 'accelerate'
      when 'advanced' then 'advanced'
      when 'momentum' then 'momentum'
      when 'rainmaker' then 'rainmaker'
      else
        package_name
      end
    end
  end

  def growth_plan_level
    case growth_plan_key
    when 'start' then 1
    when 'grow' then 2
    when 'momentum', 'accelerate' then 3
    when 'rainmaker', 'advanced' then 4
    else 0
    end
  end

  def eligible_for_free_custom_domain?
    growth_plan_level.positive?
  end

  def grader_report_limit
    case growth_plan_level
    when 1 then 100
    when 2 then 200
    when 3, 4 then 300
    else 5
    end
  end

  def grader_report_limit_exceeded?
    grader_report_limit < this_month_grader_reports.size
  end

  def user_limit
    case growth_plan_level
    when 1
      number_of_users&.positive? ? number_of_users : 1
    when 2
      number_of_users&.positive? ? number_of_users : 5
    when 3, 4
      Float::INFINITY
    else
      0
    end
  end

  def user_limit_exceeded?
    user_limit <= users.normal.count
  end

  def strategy_limit
    return lead_strategy_limit if lead_strategy_limit.present?

    case growth_plan_level
    when 0 then 0
    when 1 then 20
    else Float::INFINITY
    end
  end

  def prospecting_limit
    case growth_plan_level
    when 0 then 0
    when 1 then 10
    when 2 then 1000
    else 2500
    end
  end
end
