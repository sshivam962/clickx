# frozen_string_literal: true

module GoogleAnalytics
  class LandingPages
    include GoogleApiAuth

    def initialize(business, params)
      @business = business
      @params = params
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
    end

    def fetch
      ga_data = {}
      # Data for table
      metrics = 'ga:pageviews,ga:pageviewsPerSession,ga:sessions,ga:avgSessionDuration'
      dimensions = 'ga:pagePath'
      sort = '-ga:pageviews'
      filter = ''
      resp = common_utils.fetch_analytics_data(profile_id, dimensions, metrics, @client, @params,
                                               start_date, end_date, filter, nil, sort)
      response = ActiveSupport::JSON.decode(resp)

      ga_data['table_data'] = get_network_landing_page_hash(response)

      # Data for chart
      metrics = 'ga:entrances'
      dimensions = 'ga:deviceCategory'
      sort = '-ga:entrances'
      resp = common_utils.fetch_analytics_data(profile_id, dimensions, metrics, @client, @params,
                                               start_date, end_date, nil, nil, sort)

      response = ActiveSupport::JSON.decode(resp)
      ga_data['chart_data'] = google_landing_pages_chart_hash(response)
      ga_data['graph_data'] = get_landing_page_stats
      ga_data
    end

    def get_landing_page_stats
      data = {}
      graph_option = params[:graph_option] || 'date'
      metrics = 'ga:sessions'
      dimensions = "ga:hasSocialSourceReferral,ga:#{graph_option},ga:date"
      dimensions = "ga:hasSocialSourceReferral,ga:#{graph_option}" if graph_option == 'date'
      sort = 'ga:date'
      resp = common_utils.fetch_analytics_data(profile_id, dimensions, metrics, @client, @params,
                                               start_date, end_date, nil, nil, sort)
      resp = ActiveSupport::JSON.decode(resp)

      resp = resp['rows'].partition { |v| v[0] == 'No' }
      data[:all_sessions] = filter_data(resp[0], graph_option)
      data[:social_sessions] = filter_data(resp[1], graph_option)
      data
    end

    def filter_data(rows, graph_option)
      data =
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
      get_landing_page_chart_data(data)
    end

    private

    attr_reader :business, :params

    def auth_client
      @_auth_google_client ||=
        get_google_client(business, Token::AnalyticsAccessToken)
    end

    def start_date
      @start_date ||=
        params.fetch(:start_date, Time.zone.today - 30.days).to_date
              .strftime('%Y-%m-%d')
    end

    def end_date
      @_end_date ||=
        params.fetch(:end_date, Time.zone.today).to_date.strftime('%Y-%m-%d')
    end

    def profile_id
      business.google_analytics_id
    end

    def common_utils
      @_common_utils ||= GoogleAnalytics::CommonUtils.new
    end

    def get_network_landing_page_hash(site_stats)
      sites = []
      if site_stats && site_stats['rows']
        site_stats['rows'].each do |row|
          sites << {
            site: row[0],
            sessions: row[3],
            page_views: row[1],
            avg_session:  Time.at(row[4].to_i).utc.strftime('%H:%M:%S'),
            data_hub: row[5].to_i,
            page_per_session: row[2].to_f.round(2)
          }
        end
      end
      sites
    end

    def google_landing_pages_chart_hash(response)
      rows = response['rows'].to_h
      sum = rows.values.map(&:to_f).reduce(:+)
      rows.each { |k, v| rows[k] = (100 * v.to_f) / sum }
    end

    def get_landing_page_chart_data(rows)
      data = {}
      chart_type = params[:chart_type] || 'default'
      sum = 0
      if chart_type == 'rainfall'
        rows.each do |row|
          sum += row[1]
          data[row[0]] = sum
        end
      elsif chart_type == 'default'
        data = rows
      end
      data
    end

    def reset_hash_index_for_week_or_month(rows)
      week_or_month = 0
      year = 0
      data = {}
      date = 0
      sum = 0
      rows.each do |row|
        prev_week_or_month = week_or_month
        prev_year = year
        week_or_month = row[1]
        year = row[2].first(4)
        if prev_week_or_month == week_or_month && prev_year == year
          sum += row[3].to_i
        else
          data[date] = sum unless prev_week_or_month.to_i.zero?
          date = row[2]
          sum = row[3].to_i
        end
      end
      data[date] = sum
      data
    end

    def reset_hash_index_for_year(rows)
      data = {}
      year = 0
      sum = 0
      rows.each do |row|
        prev_year = year
        year = row[1]
        if prev_year == year
          sum += row[3].to_i
        else
          data["#{prev_year}0101"] = sum unless prev_year.to_i.zero?
          sum = row[3].to_i
        end
      end
      data["#{year}0101"] = sum
      data[@start_date.split('-').join] = data.delete("#{@start_date.split('-')[0]}0101")
      data
    end

    def reset_hash_index_for_date(rows)
      rows
        .map { |row| [row[1], row[2].to_i] }
        .to_h
    end
  end
end
