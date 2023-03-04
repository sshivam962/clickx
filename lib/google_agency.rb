# frozen_string_literal: true

module GoogleAgency
  require 'google/apis/analytics_v3'

  def visitors_analytic_data(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    data = {}
    metrics = 'ga:hits'
    visitors = fetch_visits_analytics_data(profile_id, metrics)

    time_gap = Date.parse(end_date) - Date.parse(start_date) unless end_date == 'today'
    @start_date = end_date == 'today' ? '1daysAgo' : (Date.parse(start_date) - time_gap - 1).to_s
    @end_date = end_date == 'today' ? 'yesterday' : (Date.parse(start_date) - 1).to_s

    prev_visitors = fetch_visits_analytics_data(profile_id, metrics)
    net_visitors = get_percentage visitors, prev_visitors
    data[:visitors] = visitors
    data[:net_visitors] = net_visitors
    data
  end

  def fetch_visits_analytics_data(profile_id, metrics)
    ids = "ga:#{profile_id}"
    resp = @client.get_ga_data(ids, @start_date, @end_date, metrics)
    result = ActiveSupport::JSON.decode(resp)
    result['totalsForAllResults']['ga:hits']
  end

  def init(auth_client, start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    @client = Google::Apis::AnalyticsV3::AnalyticsService.new
    @client.authorization = auth_client
    @client
  end

  def get_percentage(new_value, old_value)
    percentage = if old_value.to_i.zero?
                   0
                 else
                   (((new_value.to_f - old_value.to_f) / old_value.to_f) * 100.0).round.to_s
                 end
  end

  def get_start_date(start_period)
    start_date = case start_period
                 when 'This Month' then (Date.current - 1.month + 1.day).strftime '%Y-%m-%d'
                 when 'This Week' then (Date.current - 1.week + 1.day).strftime '%Y-%m-%d'
                 when 'Last Month' then (Date.current - 2.months + 1.day).strftime '%Y-%m-%d'
                 when 'Last Week' then (Date.current - 2.weeks + 1.day).strftime '%Y-%m-%d'
                 when 'Today' then '0daysAgo'
                 else (Date.current - 1.month + 1.day).strftime '%Y-%m-%d'
                 end
  end

  def get_end_date(start_period)
    end_date = case start_period
               when 'This Month' then Date.current.strftime '%Y-%m-%d'
               when 'This Week' then Date.current.strftime '%Y-%m-%d'
               when 'Last Month' then (Date.current - 1.month).strftime '%Y-%m-%d'
               when 'Last Week' then (Date.current - 1.week).strftime '%Y-%m-%d'
               when 'Today' then 'today'
               else Date.current.strftime '%Y-%m-%d'
               end
  end
end
