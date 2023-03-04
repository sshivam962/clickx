# frozen_string_literal: true

module GoogleAnalytics
  class Goals
    include GoogleApiAuth

    def initialize(business, params)
      @business = business
      @params = params
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
    end

    def fetch
      ga_data = {}
      metrics = 'ga:goalCompletionsAll,ga:goalValueAll,ga:goalConversionRateAll,ga:goalAbandonRateAll'
      dimensions = 'ga:goalCompletionLocation'
      sort = 'ga:goalCompletionLocation'
      resp = common_utils.fetch_analytics_data(profile_id, dimensions, metrics, @client, @params,
                                               start_date, end_date, nil, nil, sort)
      site_stats = ActiveSupport::JSON.decode(resp)
      ga_data['table_data'] = get_goals_data(site_stats)
      ga_data['chart_data'] = get_goals_stats
      ga_data
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

    def get_goals_stats
      data = {}
      graph_option = params[:graph_option] || 'date'
      metrics = 'ga:goalCompletionsAll,ga:goalValueAll,ga:sessions,ga:goalAbandonRateAll'
      dimensions = "ga:#{graph_option},ga:year"
      dimensions = "ga:#{graph_option}" if graph_option == 'date' || graph_option == 'year'

      resp = common_utils.fetch_analytics_data(profile_id, dimensions, metrics, @client, @params,
                                               start_date, end_date, nil, nil, nil)
      resp = ActiveSupport::JSON.decode(resp)
      data[:total_stats] = get_goal_chart_data(resp)
      result =
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
      data[:chart_rows] = get_search_chart_data(result)
      data
    end

    def get_goal_chart_data(chart_data)
      data = {}
      chart_data['totalsForAllResults']&.each do |k, v|
        data.merge!(k => v.to_f.round(2))
      end
      data
    end

    def get_goals_data(site_stats)
      sites = []
      if site_stats && site_stats['rows']
        sites =
          site_stats['rows'].map do |row|
            { site: row[0].split('/').second,
              goal_completion: row[1].to_i,
              goal_value: row[2].to_f.round(2),
              goal_conversion: row[3].to_f.round(2),
              goal_abandonment: row[4].to_f.round(2) }
          end
      end
      sites
    end

    def get_search_chart_data(chart_data)
      chart_type = params[:chart_type] || 'default'
      data = {}
      sum = [0, 0, 0, 0]
      if chart_type == 'rainfall'
        chart_data.each do |row|
          sum = sum.zip(row[1]).map { |x, y| x.to_f + y.to_f }
          data.merge!(row[0] => sum)
        end
      elsif chart_type == 'default'
        chart_data&.each do |row|
          data.merge!(row[0] => (row[1]).map(&:to_f))
        end
      end
      data
    end
  end
end
