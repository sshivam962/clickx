# frozen_string_literal: true

module DateUtils
  FORMAT = '%Y-%m-%d'

  def start_date_from_date_string(date_range, compared_to = false)
    date_range = set_date_range(date_range) if compared_to

    case date_range
    when 'today' then Date.current.strftime(FORMAT)
    when 'yesterday' then (Date.current - 1.day).strftime(FORMAT)
    when 'day_before_yesterday' then (Date.current - 2.days).strftime(FORMAT)
    when 'this_week' then Date.current.beginning_of_week.strftime(FORMAT)
    when 'last_week' then (Date.current.beginning_of_week - 1.week).strftime(FORMAT)
    when 'week_before_last_week' then (Date.current.beginning_of_week - 2.weeks).strftime(FORMAT)
    when 'last_10_days' then (Date.current - 10.days).strftime(FORMAT)
    when 'this_month' then Date.current.beginning_of_month.strftime(FORMAT)
    when 'last_month' then (Date.current.beginning_of_month - 1.month).strftime(FORMAT)
    when 'last_month_partial' then (Date.current.beginning_of_month - 1.month).strftime(FORMAT)
    when 'month_before_last_month' then (Date.current.beginning_of_month - 2.months).strftime(FORMAT)
    when 'last_30_days' then (Date.current - 30.days).strftime(FORMAT)
    when 'previous_30_days' then (Date.current - 60.days).strftime(FORMAT)
    when 'this_quarter' then Date.current.beginning_of_quarter.strftime(FORMAT)
    when 'last_quarter' then (Date.current.beginning_of_quarter - 3.months).strftime(FORMAT)
    when 'quarter_before_last_quarter' then (Date.current.beginning_of_quarter - 6.months).strftime(FORMAT)
    when 'this_year' then Date.current.beginning_of_year.strftime(FORMAT)
    when 'last_year' then (Date.current.beginning_of_year - 1.year).strftime(FORMAT)
    when 'year_before_last_year' then (Date.current.beginning_of_year - 2.years).strftime(FORMAT)
    else
      Rails.logger.info '[DateUtils] Invalid date range'
      false
    end
  end

  def end_date_from_date_string(date_range, compared_to = false)
    date_range = set_date_range(date_range) if compared_to

    case date_range
    when 'today' then Date.current.strftime(FORMAT)
    when 'yesterday' then (Date.current - 1.day).strftime(FORMAT)
    when 'day_before_yesterday' then (Date.current - 2.days).strftime(FORMAT)
    when 'this_week' then Date.current.strftime(FORMAT)
    when 'last_week' then (Date.current.beginning_of_week - 1.day).strftime(FORMAT)
    when 'week_before_last_week' then (Date.current.beginning_of_week - 1.week - 1.day).strftime(FORMAT)
    when 'last_10_days' then Date.current.strftime(FORMAT)
    when 'this_month' then Date.current.strftime(FORMAT)
    when 'last_month' then (Date.current.beginning_of_month - 1.day).strftime(FORMAT)
    when 'last_month_partial' then (Date.current - 1.month).strftime(FORMAT)
    when 'month_before_last_month' then (Date.current.beginning_of_month - 1.month - 1.day).strftime(FORMAT)
    when 'last_30_days' then (Date.current - 1.day).strftime(FORMAT)
    when 'previous_30_days' then (Date.current - 31.days).strftime(FORMAT)
    when 'this_quarter' then Date.current.strftime(FORMAT)
    when 'last_quarter' then (Date.current.beginning_of_quarter - 1.day).strftime(FORMAT)
    when 'quarter_before_last_quarter' then (Date.current.beginning_of_quarter - 3.months - 1.day).strftime(FORMAT)
    when 'this_year' then Date.current.strftime(FORMAT)
    when 'last_year' then (Date.current.beginning_of_year - 1.day).strftime(FORMAT)
    when 'year_before_last_year' then (Date.current.beginning_of_year - 1.year - 1.day).strftime(FORMAT)
    else
      Rails.logger.info '[DateUtils] Invalid date range'
      false
    end
  end

  def start_date_cmp_from_date_string(compared_to)
    case compared_to
    when 'last_month' then (Date.current.beginning_of_month - 1.month).strftime(FORMAT)
    when 'year_before' then (Date.current.beginning_of_year - 1.year).strftime(FORMAT)
    when 'previous_30_days' then (Date.current - 31.days).strftime(FORMAT)
    else
      Rails.logger.info '[DateUtils] Invalid date range'
      false
    end
  end

  def end_date_cmp_from_date_string(compared_to)
    case compared_to
    when 'last_month' then (Date.current.beginning_of_month - 1.day).strftime(FORMAT)
    when 'year_before' then (Date.current.beginning_of_year - 1.day).strftime(FORMAT)
    when 'previous_30_days' then (Date.current - 1.day).strftime(FORMAT)
    else
      Rails.logger.info '[DateUtils] Invalid date range'
      false
    end
  end

  private

  def set_date_range(date_range)
    case date_range
    when 'today' then 'yesterday'
    when 'yesterday' then 'day_before_yesterday'
    when 'this_week' then 'last_week'
    when 'last_week' then 'week_before_last_week'
    when 'this_month' then 'last_month_partial'
    when 'last_month' then 'month_before_last_month'
    when 'last_30_days' then 'previous_30_days'
    when 'this_quarter' then 'last_quarter'
    when 'last_quarter' then 'quarter_before_last_quarter'
    when 'this_year' then 'last_year'
    when 'last_year' then 'year_before_last_year'
    else
      Rails.logger.info '[DateUtils] Invalid date range'
      false
    end
  end
end
