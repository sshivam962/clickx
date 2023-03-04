# frozen_string_literal: true

module GoogleAnalytics
  class SearchesData
    include GoogleApiAuth

    def initialize(business, params)
      @business = business
      @params = params
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
      @metrics = 'ga:percentNewSessions,ga:sessions,ga:users,ga:bounceRate,ga:avgSessionDuration,ga:pageviewsPerSession'
    end

    def fetch
      ga_search_data = {}
      ga_search_data['chart_data'] = get_searches_stats
      dimensions = 'ga:keyword'
      sort = '-ga:sessions'
      segment = 'sessions::condition::ga:medium==organic'
      response = common_utils.fetch_analytics_data(profile_id, dimensions, @metrics, @client, @params,
                                                   start_date, end_date, nil, segment, sort)

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

    def get_searches_stats
      graph_option = params[:graph_option] || 'date'
      dimensions = "ga:#{graph_option},ga:year"
      segment = 'sessions::condition::ga:medium==organic'

      dimensions = "ga:#{graph_option}" if graph_option == 'year' || graph_option == 'date'

      resp = common_utils.fetch_analytics_data(profile_id, dimensions, @metrics, @client, @params,
                                               start_date, end_date, nil, segment, sort = nil)
      resp = ActiveSupport::JSON.decode(resp)
      resp['rows'] =
        case graph_option
        when 'date'
          common_utils.reset_hash_index_for_date(resp['rows'])
        when 'week'
          common_utils.reset_hash_index_for_week(resp['rows'])
        when 'month'
          common_utils.reset_hash_index_for_month(resp['rows'])
        when 'year'
          common_utils.reset_hash_index_for_year(resp['rows'])
        end

      result = get_search_chart_data(resp)
    end

    def get_search_chart_data(chart_data)
      chart_type = params[:chart_type] || 'default'
      total_stats = {}
      chart_data['totalsForAllResults'].each do |k, v|
        total_stats.merge!(k => v.to_f.round(2))
      end

      chart_stats = {}
      sum = [0, 0, 0, 0, 0]
      if chart_type == 'rainfall'
        chart_data['rows'].each do |row|
          sum = sum.zip(row[1]).map { |x, y| x.to_f + y.to_f }
          chart_stats.merge!(row[0] => sum)
        end
      elsif chart_type == 'default'
        chart_data['rows'].each do |row|
          chart_stats.merge!(row[0] => (row[1]).map(&:to_f))
        end
      end
      { total_stats: total_stats, chart_rows: chart_stats }
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

    def get_search_keywords(keyword_stats)
      keywords = []
      if keyword_stats && keyword_stats['rows']
        keyword_stats['rows'].each do |row|
          keywords << {
            keyword: row[0],
            visits: row[2],
            new_visits: row[1].to_f.round(2),
            bounce: row[3].to_f.round(2),
            avg_session: common_utils.time_form(row[4].to_i),
            page_per_session: row[5].to_f.round(2)
          }
        end
      end
      keywords
    end

    def common_utils
      @_common_utils ||= GoogleAnalytics::CommonUtils.new
    end
  end
end
