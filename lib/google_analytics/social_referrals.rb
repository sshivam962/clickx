# frozen_string_literal: true

module GoogleAnalytics
  class SocialReferrals
    include GoogleApiAuth
    CACHE_DURATION = 60 * 60 * 24

    def self.fetch(business, params)
      new(business, params).fetch
    end

    def initialize(business, params)
      @business = business
      @params = params
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
    end

    def fetch
      social_network_referrals
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

    def social_network_referrals
      data = {}
      data['table_data'] = network_referral_sites
      data['graph_data'] = social_session_graph
      data
    end

    def network_referral_sites
      metrics = 'ga:sessions,ga:pageviews,ga:avgSessionDuration,ga:pageviewsPerSession'
      dimensions = 'ga:socialNetwork'
      sort = '-ga:sessions'

      response = fetch_analytics_data(dimensions, metrics, sort)
      get_network_referral_sites_hash(response)
    end

    def social_session_graph
      data = {}
      metrics = 'ga:sessions'
      dimensions = set_dimensions
      sort = 'ga:date'

      resp = fetch_analytics_data(dimensions, metrics, sort)
      split_resp = resp['rows'].partition { |v| v[0] == 'No' }

      reseted_data = reset_data_based_on_graph_option(split_resp[0])
      data[:all_sessions] = get_landing_page_chart_data(reseted_data)

      reseted_data = reset_data_based_on_graph_option(split_resp[1])
      data[:social_sessions] = get_landing_page_chart_data(reseted_data)

      data
    end

    def fetch_analytics_data(dimensions, metrics, sort)
      ids = "ga:#{profile_id}"
      signature = generate_signature(dimensions, metrics, sort)

      result =
        APICache.get(signature, cache: CACHE_DURATION, timeout: 60) do
          @client.get_ga_data(ids, start_date, end_date, metrics,
                              dimensions: dimensions,
                              sort: sort)
        end
      ActiveSupport::JSON.decode(result)
    rescue StandardError
      {}
    end

    def get_network_referral_sites_hash(site_stats)
      if site_stats && site_stats['rows']
        site_stats['rows'].map do |row|
          { site: row[0],
            sessions: row[1],
            page_views: row[2],
            avg_session: time_form(row[3].to_i),
            page_per_session: row[4].to_f.round(2) }
        end
      end
    end

    def generate_signature(dimensions, metrics, sort)
      key = params.merge('ids'        => "ga:#{profile_id}",
                         'start-date' => start_date,
                         'end-date'   => end_date,
                         'dimensions' => dimensions,
                         'metrics'    => metrics,
                         'sort'       => sort)
      Digest::SHA1.digest(key.to_s)
    end

    def set_dimensions
      graph_option = params[:graph_option] || 'date'
      dimensions = "ga:hasSocialSourceReferral,ga:#{graph_option},ga:date"
      dimensions = "ga:hasSocialSourceReferral,ga:#{graph_option}" if graph_option == 'date'
      dimensions
    end

    def time_form(seconds)
      format = seconds < 3600 ? '%M:%S' : '%H:%M:%S'
      Time.at(seconds).utc.strftime(format)
    end

    def reset_data_based_on_graph_option(social_sessions)
      graph_option = params[:graph_option] || 'date'
      case graph_option
      when 'date'
        reset_index_to_date(social_sessions)
      when 'week'
        reset_index_to_week_or_month(social_sessions)
      when 'month'
        reset_index_to_week_or_month(social_sessions)
      when 'year'
        reset_index_to_year(social_sessions)
      end
    end

    def reset_index_to_week_or_month(rows)
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

    def reset_index_to_year(rows)
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

    def reset_index_to_date(rows)
      rows
        .map { |row| [row[1], row[2].to_i] }
        .to_h
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
  end
end
