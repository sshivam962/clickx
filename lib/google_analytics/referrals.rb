# frozen_string_literal: true

module GoogleAnalytics
  class Referrals
    include GoogleApiAuth

    def initialize(business, params)
      @business = business
      @params = params
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
    end

    def fetch
      ga_data = {}
      metrics = 'ga:percentNewSessions,ga:sessions,ga:bounceRate,ga:avgSessionDuration,ga:pageviewsPerSession'
      dimensions = 'ga:fullReferrer'
      sort = '-ga:sessions'

      resp = common_utils.fetch_analytics_data(profile_id, dimensions, metrics, @client, @params,
                                               start_date, end_date, nil, nil, sort)
      site_stats = ActiveSupport::JSON.decode(resp)
      ga_data['table_data'] = get_sites_data(site_stats)
      ga_data['chart_data'] = get_referral_stats
      ga_data
    end

    def get_referral_stats
      graph_option = params[:graph_option] || 'date'
      metrics = 'ga:percentNewSessions,ga:sessions,ga:users,ga:bounceRate,ga:avgSessionDuration,ga:pageviewsPerSession'
      dimensions = "ga:#{graph_option},ga:year"
      segment = 'sessions::condition::ga:medium==referral'
      dimensions = "ga:#{graph_option}" if graph_option == 'date' || graph_option == 'year'

      resp = common_utils.fetch_analytics_data(profile_id, dimensions, metrics, @client, @params,
                                               start_date, end_date, nil, segment, nil)
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
      get_referrals_data(resp)
     end

    def get_referrals_data(chart_data)
      chart_type = params[:chart_type] || 'default'
      total_stats = {}
      chart_data['totalsForAllResults']&.each do |k, v|
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
        chart_data['rows']&.each do |row|
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

    def get_sites_data(site_stats)
      sites = []
      if site_stats && site_stats['rows']
        site_stats['rows'].each do |row|
          sites << {
            site: row[0].split('/').first,
            visits: row[2],
            new_visits: row[1].to_f.round(2),
            bounce: row[3].to_f.round(2),
            avg_session: common_utils.time_form(row[4].to_i),
            page_per_session: row[5].to_f.round(2)
          }
        end
      end
      sites
    end
  end
end
