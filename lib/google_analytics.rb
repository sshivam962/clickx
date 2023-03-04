# frozen_string_literal: true

require 'date'
require 'google_api_auth'
require 'google/apis'
require 'google/apis/analytics_v3'
require 'google/api_client/client_secrets'
module GoogleAnalytics
  include GoogleApiAuth
  CACHE_DURATION = 60 * 60 * 12 # 12 hours

  def get_google_api_data(auth_client, profile_id, start_date, end_date, chart_type = 'default', graph_option = 'date')
    # 'ids'        => "ga:893744",
    init(auth_client, start_date, end_date)

    ga_data = { 'users' => [],
                'visit_status' => { 'referral' => 0, 'organic' => 0, 'direct' => 0, 'paid' => 0 },
                'users_data' => {}, 'users_data_previous' => {} }

    # generic stats
    response = fetch_analytics_data(profile_id, '', 'ga:users,ga:pageviews,ga:sessions')

    ga_data['totals'] = ActiveSupport::JSON.decode(response)['totalsForAllResults'] || {}

    visit_stats = get_visit_stats(profile_id)
    ga_data['visit_status'] = { 'referral' => visit_stats[0], 'organic' => visit_stats[1], 'direct' => visit_stats[2], 'paid' => visit_stats[3], 'social' => visit_stats[4], 'email' => visit_stats[5], 'others' => visit_stats[6] }
    ga_data['users_data'] = get_users_stats(profile_id, chart_type, graph_option)
    ga_data['users_data'] = insert_null(ga_data['users_data'], start_date, end_date)
    ga_data['users_data_previous'] = get_users_stats(profile_id, chart_type, graph_option)
    ga_data
  end

  def get_google_search_api_data(auth_client, profile_id, start_date, end_date, search_type = 'organic')
    init(auth_client, start_date, end_date)
    ga_search_data = {}

    # chart data
    metrics = 'ga:percentNewSessions,ga:sessions,ga:bounceRate,ga:sessionDuration,ga:pageviewsPerSession'
    dimensions = 'ga:date'

    sort = 'ga:date'
    case search_type
    when 'all'
      segment = 'sessions::condition::ga:medium=~^(cpc|ppc|cpa|cpm|cpv|cpp|organic)$'
    when 'paid'
      segment = 'sessions::condition::ga:medium=~^(cpc|ppc|cpa|cpm|cpv|cpp)$'
    when 'organic'
      segment = 'sessions::condition::ga:medium==organic'
    end
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort)
    ga_search_data['chart_data'] = get_search_chart_data(ActiveSupport::JSON.decode(response))
    ga_search_data['chart_data'][:chart_rows] = insert_null(ga_search_data['chart_data'][:chart_rows],
                                                            start_date, end_date)
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort)
    ga_search_data['chart_data_previous'] = get_search_chart_data(ActiveSupport::JSON.decode(response))

    # keyword table data
    dimensions = 'ga:keyword'
    sort = '-ga:sessions'
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort)

    keyword_stats = ActiveSupport::JSON.decode(response)

    keyword_totals = keyword_stats['totalsForAllResults']
    ga_search_data['keywords_stats'] = get_search_keywords(keyword_stats)
    ga_search_data['keyword_totals'] = {
      visits: keyword_totals['ga:sessions'],
      new_visits: keyword_totals['ga:percentNewSessions'],
      avg_session: keyword_totals['ga:avgSessionDuration'],
      bounce: keyword_totals['ga:bounceRate'],
      page_views: keyword_totals['ga:pageviewsPerSession']
    }

    ga_search_data
  end

  def get_referral_data(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    metrics = 'ga:percentNewSessions,ga:sessions,ga:bounceRate,ga:sessionDuration,ga:pageviewsPerSession'
    dimensions = 'ga:fullReferrer'
    sort = '-ga:sessions'
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort)
    site_stats = ActiveSupport::JSON.decode(response)
    ga_data['table_data'] = get_sites_data(site_stats)

    # graph data
    segment = 'sessions::condition::ga:medium==referral'
    dimensions = 'ga:date'
    sort = 'ga:date'

    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort)
    ga_data['chart_data'] = get_search_chart_data(ActiveSupport::JSON.decode(response))
    ga_data['chart_data'][:chart_rows] = insert_null(ga_data['chart_data'][:chart_rows],
                                                     start_date, end_date)
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort)
    ga_data['chart_data_previous'] = get_search_chart_data(ActiveSupport::JSON.decode(response))

    ga_data
  end

  def get_locale_data(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    metrics = 'ga:percentNewSessions,ga:sessions,ga:bounceRate,ga:sessionDuration,ga:pageviewsPerSession'
    dimensions = 'ga:country'
    sort = '-ga:sessions'
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort)
    site_stats = ActiveSupport::JSON.decode(response)
    # tabular data
    ga_data['table_data'] = get_sites_data(site_stats)
    ga_data

    # TODO: hash as per site stats
  end

  def get_campaigns_data(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    metrics = 'ga:sessions,ga:percentNewSessions,ga:newUsers,ga:bounceRate,ga:pageviewsPerSession,ga:avgSessionDuration,ga:goalConversionRateAll,ga:goalCompletionsAll'
    dimensions = 'ga:campaign'
    sort = '-ga:sessions'
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort)
    campaigns_stats = ActiveSupport::JSON.decode(response)
    # tabular data
    ga_data['table_data'] = get_campaign_data(campaigns_stats)

    chart_data = get_campaign_chart_data(ActiveSupport::JSON.decode(response))
    totals = chart_data[:total_stats]

    ga_data['totals'] = {
      sessions: totals['ga:sessions'],
      avg_session: totals['ga:avgSessionDuration'],
      new_users: totals['ga:newUsers'],
      bounce_rate: totals['ga:bounceRate'],
      page_views: totals['ga:pageviewsPerSession'],
      new_sessions: totals['ga:percentNewSessions']
    }
    ga_data
  end

  def get_goal_data(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    metrics = 'ga:goalCompletionsAll,ga:goalValueAll,ga:goalConversionRateAll,ga:goalAbandonRateAll'
    dimensions = 'ga:goalCompletionLocation'
    sort = 'ga:goalCompletionLocation'

    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort)
    site_stats = ActiveSupport::JSON.decode(response)
    ga_data['table_data'] = get_goals_data(site_stats)

    # graph data
    segment = nil
    metrics = 'ga:goalCompletionsAll,ga:goalValueAll,ga:sessions,ga:goalAbandonRateAll'
    dimensions = 'ga:date'
    sort = 'ga:date'
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort)
    ga_data['chart_data'] = get_goal_chart_data(ActiveSupport::JSON.decode(response))
    ga_data['chart_data'][:chart_rows] = insert_null(ga_data['chart_data'][:chart_rows],
                                                     start_date, end_date)
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort)
    ga_data['chart_data_previous'] = get_goal_chart_data(ActiveSupport::JSON.decode(response))

    ga_data['total_session'] = ga_data['chart_data'][:total_stats]['ga:sessions']

    ga_data
  end

  def get_google_social_overview(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    metrics = 'ga:sessions'
    dimensions = 'ga:socialNetwork'
    sort = '-ga:sessions'
    segment = nil
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort))
    ga_data = response['rows']
    ga_data
  end

  def get_google_social_overview_urls(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    metrics = 'ga:sessions'
    sort = '-ga:sessions'
    dimensions = 'ga:socialActivityContentUrl, ga:hasSocialSourceReferral'
    segment = nil
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, nil, segment, sort))
    response['rows'].delete_if { |i| i[1] == 'No' }
    ga_data = response['rows'].first(10)
    ga_data
  end

  def get_google_social_network_referral(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    metrics = 'ga:sessions,ga:pageviews,ga:avgSessionDuration,ga:pageviewsPerSession'
    dimensions = 'ga:socialNetwork'
    sort = '-ga:sessions'
    filter = "ga:socialNetwork!@'(not set)'"
    segment = nil
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, filter, segment, sort))
    ga_data['table_data'] = get_network_referral_sites_hash(response)

    metrics = 'ga:sessions'
    dimensions = 'ga:hasSocialSourceReferral,ga:date'
    sort = 'ga:date'
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort))
    ga_data['graph_data'] = social_session_graph_data(response)
    if end_date.to_date.strftime('%d') == Time.zone.now.strftime('%d') &&
       start_date.to_date.strftime('%d') == '01'
      date = Date.parse(@end_date) + 1.day
      (date..@end_date.to_date.end_of_month).each do |day|
        ga_data['graph_data']['all_sessions'][day.to_s.tr('-', '')] = nil
        ga_data['graph_data']['social_sessions'].merge!(day.to_s.tr('-', '') => nil)
      end
      @start_date = start_date.to_date.prev_month.beginning_of_month.to_s
      @end_date = @start_date.to_date.end_of_month.to_s
    else
      time_gap = (end_date.to_date - start_date.to_date).to_i + 1
      @start_date = (start_date.to_date - time_gap.days).to_s
      @end_date = (start_date.to_date - 1.day).to_s
    end
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort)
    ga_data['graph_data_previous'] = social_session_graph_data(ActiveSupport::JSON.decode(response))

    ga_data
  end

  def direct_visit_count(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    response = fetch_analytics_data(profile_id, 'ga:date', 'ga:sessions')
    resp = ActiveSupport::JSON.decode(response)['rows']
    resp.to_h
  end

  def get_google_social_landings(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    metrics = 'ga:sessions,ga:pageviews,ga:avgSessionDuration,ga:pageviewsPerSession,ga:users'
    dimensions = 'ga:hasSocialSourceReferral, ga:landingPagePath'
    sort = '-ga:sessions'
    filter = "ga:hasSocialSourceReferral=='Yes'"
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, filter, nil, sort))
    response['rows'].delete_if { |i| i[0] == 'No' }
    ga_data['table_data'] = get_network_landing_page_hash(response)

    metrics = 'ga:sessions'
    dimensions = 'ga:hasSocialSourceReferral,ga:date'
    sort = 'ga:date'
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort))
    ga_data['graph_data'] = social_session_graph_data(response)

    time_gap = Date.parse(end_date) - Date.parse(start_date)
    @start_date = (Date.parse(start_date) - time_gap - 1).to_s
    @end_date = (Date.parse(start_date) - 1).to_s
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort)
    ga_data['graph_data_previous'] = social_session_graph_data(ActiveSupport::JSON.decode(response))

    ga_data
  end

  def get_google_landing_pages(auth_client, profile_id, start_date, end_date)
    init(auth_client, start_date, end_date)
    ga_data = {}
    # Data for table
    metrics = 'ga:bounces,ga:entrances,ga:sessionDuration,ga:pageviews,ga:pageviewsPerSession,ga:sessions'
    dimensions = 'ga:landingPagePath'
    sort = '-ga:entrances'
    filter = ''
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, filter, nil, sort))
    ga_data['table_data'] = get_network_landing_page_hash(response)

    # Data for chart
    metrics = 'ga:entrances'
    dimensions = 'ga:deviceCategory'
    sort = '-ga:entrances'
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort))
    ga_data['chart_data'] = google_landing_pages_chart_hash response

    # Data for graph
    metrics = 'ga:sessions'
    dimensions = 'ga:hasSocialSourceReferral,ga:date'
    sort = 'ga:date'
    response = ActiveSupport::JSON.decode(fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort))
    ga_data['graph_data'] = social_session_graph_data(response)
    # TODO: refactor
    if end_date.to_date.strftime('%d') == Time.zone.now.strftime('%d') &&
       start_date.to_date.strftime('%d') == '01'
      date = Date.parse(@end_date) + 1.day
      (date..@end_date.to_date.end_of_month).each do |day|
        ga_data['graph_data']['all_sessions'][day.to_s.tr('-', '')] = nil
        ga_data['graph_data']['social_sessions'].merge!(day.to_s.tr('-', '') => nil)
      end
      @start_date = start_date.to_date.prev_month.beginning_of_month.to_s.to_s
      @end_date = @start_date.to_date.end_of_month.to_s
    else
      time_gap = (end_date.to_date - start_date.to_date).to_i + 1
      @start_date = (start_date.to_date - time_gap.days).to_s
      @end_date = (start_date.to_date - 1.day).to_s
    end
    response = fetch_analytics_data(profile_id, dimensions, metrics, nil, nil, sort)
    ga_data['graph_data_previous'] = social_session_graph_data(ActiveSupport::JSON.decode(response))
    ga_data
  end

  def fetch_analytics_data(profile_id, dimensions, metrics, filters = nil, segments = nil, sort = nil, max_results = nil)
    params = {
      'ids'        => "ga:#{profile_id}",
      'start-date' => @start_date,
      'end-date'   => @end_date,
      'dimensions' => dimensions,
      'metrics'    => metrics
    }

    params['filters'] = filters unless filters.nil?
    params['segments'] = segments unless segments.nil?
    params['sort'] = sort unless sort.nil?
    # @client.execute(:api_method => @analytics.data.ga.get, :parameters => params)

    ids = "ga:#{profile_id}"
    signature = Digest::SHA1.digest(params.to_s)
    APICache.get(signature, cache: CACHE_DURATION, timeout: 60) do
      if max_results.nil?
        @client.get_ga_data(ids, @start_date, @end_date, metrics,
                            dimensions: dimensions,
                            segment: segments, sort: sort)
      else
        @client.get_ga_data(ids, @start_date, @end_date, metrics,
                            dimensions: dimensions, segment: segments,
                            sort: sort, max_results: max_results)
      end
    end
  rescue StandardError
    '{}'
  end

  def get_visit_stats(profile_id)
    # direct visits
    response = fetch_analytics_data(profile_id, 'ga:source,ga:hasSocialSourceReferral,ga:medium', 'ga:sessions', 'ga:medium==referral')
    resp = ActiveSupport::JSON.decode(response)['rows']

    direct_visits = begin
                      resp[0][3].to_i
                    rescue StandardError
                      0
                    end # ["(direct)", "No", "81"] is always first row
    visit_data = begin
                   resp.delete_if { |i| i[1] == 'Yes' || i[0] == '(direct)' }
                 rescue StandardError
                   []
                 end

    # referral visits/paid visits/organic visits/email visits/other visits
    referral_visits = 0
    paid_visits = 0
    organic_visits = 0
    email_visits = 0
    other_visits = 0
    visit_data.each do |dt|
      if %w[cpa cpc cpm cpp cpv ppc].include?(dt[2])
        (paid_visits += dt[3].to_i)
      elsif dt[2].include?('organic')
        (organic_visits += dt[3].to_i)
      elsif dt[2].include?('email')
        (email_visits += dt[3].to_i)
      elsif dt[2].include?('referral')
        referral_visits += dt[3].to_i
      else
        other_visits += dt[3].to_i
      end
    end
    visit_data = []

    # social visits
    visit_count = 0
    response = fetch_analytics_data(profile_id, 'ga:socialNetwork', 'ga:sessions')
    visit_data = ActiveSupport::JSON.decode(response)['rows']
    visit_data&.delete_if { |i| i[0] == '(not set)' }
    visit_data&.collect { |i| visit_count += i[1].to_i } if visit_data
    social_visits = visit_count

    [referral_visits, organic_visits, direct_visits, paid_visits, social_visits, email_visits, other_visits]
  end

  def get_users_stats(profile_id, chart_type, graph_option)
    dimensions = "ga:#{graph_option},ga:date"
    dimensions = "ga:#{graph_option}" if graph_option == 'year' || graph_option == 'date'
    resp = fetch_analytics_data(profile_id, dimensions, 'ga:percentNewSessions,ga:sessions,ga:bounceRate,ga:sessionDuration,ga:pageviewsPerSession')
    rows = ActiveSupport::JSON.decode(resp).fetch('rows', [])
    visitor_stats =
      case graph_option
      when 'date'
        reset_hash_index_for_date(rows)
      when 'week'
        reset_hash_index_for_week_or_month(rows)
      when 'month'
        reset_hash_index_for_week_or_month(rows)
      when 'year'
        reset_hash_index_for_year(rows)
      end

    if chart_type == 'rainfall'
      visitor_stats = visitor_stats.sort_by { |k, _v| k }
      sum = [0, 0, 0, 0, 0]
      rows = {}
      visitor_stats.each do |visit|
        sum = sum.zip(visit[1]).map { |x, y| x.to_f + y.to_f }
        rows[visit[0]] = sum
      end
      visitor_stats = rows
    end
    visitor_stats
  end

  def get_search_keywords(keyword_stats)
    keywords = []
    if keyword_stats && keyword_stats['rows']
      keyword_stats['rows'].each do |row|
        keywords << {
          keyword: row[0],
          visits: row[2],
          new_visits: row[1].to_f.round(2),
          bounce: row[3].to_f.round(2),
          avg_session: time_form(row[4].to_i),
          page_per_session: row[5].to_f.round(2)
        }
      end
    end
    keywords
  end

  def get_network_landing_page_hash(site_stats)
    sites = []
    if site_stats && site_stats['rows']
      site_stats['rows'].each do |row|
        sites << {
          social_refer: row[0],
          site: row[1],
          sessions: row[2].to_i,
          page_views: row[3].to_i,
          avg_session: time_form(row[4].to_i),
          page_per_session: row[5].to_f.round(4),
          unique_visitors: row[6].to_i
        }
      end
    end
    sites
  end

  def get_network_referral_sites_hash(site_stats)
    sites = []
    if site_stats && site_stats['rows']
      site_stats['rows'].each do |row|
        sites << {
          site: row[0],
          sessions: row[1],
          page_views: row[2],
          avg_session: time_form(row[3].to_i),
          page_per_session: row[4].to_f.round(2)
        }
      end
    end
    sites
  end

  def get_sites_data(site_stats)
    sites = []
    if site_stats && site_stats['rows']
      site_stats['rows'].each do |row|
        sites << {
          site: row[0].split('/').first,
          visits: row[2],
          new_visits: row[1].to_f.round(2),
          bounce: row[3].to_f.round(2),
          avg_session: time_form(row[4].to_i),
          page_per_session: row[5].to_f.round(2)
        }
      end
    end
    sites
  end

  def get_campaign_data(campaign_stats)
    campaigns = []
    if campaign_stats && campaign_stats['rows']
      campaign_stats['rows'].drop(1).each do |row|
        campaigns << {
          name: row[0],
          sessions: row[1],
          new_sessions: row[2],
          new_users: row[3],
          bounce_rate: row[4].to_f.round(2),
          page_per_session: row[5].to_f.round(2),
          avg_session: time_form(row[6].to_i),
          goal_conversion: row[7],
          goal_completion: row[8]
        }
      end
    end
    campaigns
  end

  def get_goals_data(site_stats)
    sites = []
    if site_stats && site_stats['rows']
      site_stats['rows'].each do |row|
        sites << {
          site: row[0].split('/').second,
          goal_completion: row[1],
          goal_value: row[2],
          goal_conversion: row[3],
          goal_abandonment: row[4]
        }
      end
    end
    sites
  end

  def social_session_graph_data(resp)
    data = { 'all_sessions' => {}, 'social_sessions' => {} }
    all_ses = 0
    social_ses = 0
    return data unless resp['rows']
    resp['rows'].each do |row|
      if row[0] == 'No'
        all_ses += row[2].to_i
        social_ses += 0
        row[2] = all_ses
        data['all_sessions'][row[1]] = row[2]
        data['social_sessions'].merge!(row[1] => social_ses)
      else
        social_ses += row[2].to_i
        row[2] = social_ses
        data['social_sessions'][row[1]] = row[2]
        all_ses += row[2].to_i
        data['all_sessions'].merge!(row[1] => all_ses)
      end
    end
    data
  end

  def google_landing_pages_chart_hash(response)
    rows = response['rows'].to_h
    sum = rows.values.map(&:to_f).reduce(:+)
    rows.each { |k, v| rows[k] = (100 * v.to_f) / sum }
  end

  def get_goal_chart_data(chart_data)
    total_stats = {}
    chart_data['totalsForAllResults'].each do |k, v|
      total_stats.merge!(k => v.to_f.round(2))
    end

    chart_stats = {}
    sum = [0, 0, 0, 0]
    chart_data['rows'].each do |row|
      sum = sum.zip(row[1..4]).map { |x, y| x.to_i + y.to_i }
      chart_stats.merge!(row[0] => sum)
    end

    { total_stats: total_stats, chart_rows: chart_stats }
  end

  def get_campaign_chart_data(chart_data)
    total_stats = {}
    chart_data['totalsForAllResults'].each do |k, v|
      total_stats.merge!(k => v.to_f.round(2))
    end

    # chart_stats = {}
    # chart_data['rows'].each do |row|
    #   chart_stats.merge!(row[0] => row[1..4])
    # end

    { total_stats: total_stats }
  end

  def get_search_chart_data(chart_data)
    total_stats = {}
    chart_data['totalsForAllResults'].each do |k, v|
      total_stats.merge!(k => v.to_f.round(2))
    end

    chart_stats = {}
    sum = [0, 0, 0, 0, 0]
    chart_data['rows'].each do |row|
      sum = sum.zip(row[1..5]).map { |x, y| x.to_i + y.to_i }
      chart_stats.merge!(row[0] => sum)
    end

    { total_stats: total_stats, chart_rows: chart_stats }
  end

  def time_form(seconds)
    format = seconds < 3600 ? '%M:%S' : '%H:%M:%S'
    Time.at(seconds).utc.strftime(format)
  end

  def init(auth_client, start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    @client = Google::Apis::AnalyticsV3::AnalyticsService.new
    @client.authorization = auth_client
  end

  def insert_null(data, start_date, end_date)
    time_gap = (end_date.to_date - start_date.to_date).to_i + 1
    if end_date.to_date.strftime('%d') == Time.zone.now.strftime('%d') &&
       start_date.to_date.strftime('%d') == '01'
      date = Date.parse(@end_date) + 1.day
      (date..@end_date.to_date.end_of_month).each do |day|
        data.merge!(day.to_s.tr('-', '') => [nil, nil, nil, nil, nil])
      end
      @start_date = start_date.to_date.prev_month.beginning_of_month.to_s
      @end_date = @start_date.to_date.end_of_month.to_s
    else
      @start_date = (start_date.to_date - time_gap.to_i.days).to_s
      @end_date = (start_date.to_date - 1.day).to_s
    end
    data
  end

  private

  def reset_hash_index_for_week_or_month(rows)
    count = 0
    week_or_month = 0
    year = 0
    sum = [0, 0, 0, 0, 0]
    visitor_stats = {}
    date = 0

    rows.each do |row|
      prev_week_or_month = week_or_month
      prev_year = year
      week_or_month = row[0]
      year = row[1].first(4)
      if prev_week_or_month == week_or_month && prev_year == year
        sum = sum.zip(row[2..6]).map { |x, y| x.to_f + y.to_f }
        count += 1
      else
        visitor_stats[date] = [sum[0] / count, sum[1], sum[2] / count, sum[3], sum[4] / count] unless prev_week_or_month.to_i.zero?
        date = row[1]
        count = 1
        sum = row[2..6].map(&:to_f)
      end
    end
    visitor_stats[date] = [sum[0] / count, sum[1], sum[2] / count, sum[3], sum[4] / count]
    visitor_stats
  end

  def reset_hash_index_for_year(rows)
    visitor_stats = {}
    rows.each do |row|
      visitor_stats["#{row[0]}0101"] = row[1..5].map(&:to_f)
    end
    visitor_stats[@start_date.split('-').join] = visitor_stats.delete("#{@start_date.split('-')[0]}0101")
    visitor_stats[@end_date.split('-').join] = visitor_stats.delete("#{@end_date.split('-')[0]}0101")
    visitor_stats
  end

  def reset_hash_index_for_date(rows)
    rows
      .map { |row| [row[0], row[1..5].map(&:to_f)] }
      .to_h
  end
end
