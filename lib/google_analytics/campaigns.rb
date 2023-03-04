# frozen_string_literal: true

module GoogleAnalytics
  class Campaigns
    include GoogleApiAuth

    def initialize(business, params)
      @business = business
      @params = params
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
      @metrics = 'ga:sessions,ga:percentNewSessions,ga:newUsers,ga:bounceRate,ga:pageviewsPerSession,ga:avgSessionDuration,ga:goalConversionRateAll,ga:goalCompletionsAll'
      @dimensions = 'ga:campaign'
      @sort = '-ga:sessions'
    end

    def fetch
      ga_data = {}
      response = fetch_analytics_data
      campaigns_stats = ActiveSupport::JSON.decode(response)

      ga_data['table_data'] = get_campaign_data(campaigns_stats)
      ga_data['totals'] = get_totals_data(campaigns_stats)

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
      @business.google_analytics_id
    end

    def common_utils
      @_common_utils ||= GoogleAnalytics::CommonUtils.new
    end

    def fetch_analytics_data
      ids = "ga:#{profile_id}"
      params = {
        'ids'        => ids,
        'start-date' => start_date,
        'end-date'   => end_date,
        'dimensions' => @dimensions,
        'metrics'    => @metrics
      }
      signature = Digest::SHA1.digest(params.to_s)
      APICache.get(signature, cache: CACHE_DURATION, timeout: 60) do
        @client.get_ga_data(ids, start_date, end_date, @metrics, dimensions: @dimensions)
      end
    rescue StandardError
      '{}'
    end

    def common_utils
      @_common_utils ||= GoogleAnalytics::CommonUtils.new
    end

    def get_campaign_data(campaign_stats)
      return unless campaign_stats && campaign_stats['rows']
      campaign_stats['rows'].drop(1).map do |row|
        {
          name: row[0],
          sessions: row[1].to_i,
          new_sessions: row[2].to_f.round(2),
          new_users: row[3].to_i,
          bounce_rate: row[4].to_f.round(2),
          page_per_session: row[5].to_f.round(2),
          avg_session: common_utils.time_form(row[6].to_i),
          goal_conversion: row[7].to_f.round(2),
          goal_completion: row[8].to_i
        }
      end
    end

    def get_totals_data(campaign_stats)
      {
        sessions: campaign_stats['rows'].drop(1).sum { |x| x[1].to_i },
        new_users: campaign_stats['rows'].drop(1).sum { |x| x[3].to_i }
      }
    end
  end
end
