# frozen_string_literal: true

module GoogleAnalytics
  class SourceMedium
    attr_reader :params, :start_date, :end_date, :profile_id, :auth_client

    def initialize(start_date, end_date, auth_client, profile_id, params)
      @start_date = start_date
      @end_date = end_date
      @profile_id = profile_id
      @auth_client = auth_client
      @params = params
    end

    def get_campaigns_data
      init(auth_client)
      ga_data = {}
      metrics = 'ga:sessions,ga:percentNewSessions,ga:newUsers,ga:bounceRate,ga:pageviewsPerSession,ga:avgSessionDuration,ga:goalConversionRateAll,ga:goalCompletionsAll'
      dimensions = 'ga:sourceMedium'
      sort = '-ga:sessions'

      response =
        common_utils.fetch_analytics_data(
          profile_id, dimensions, metrics, @client, params,
          start_date, end_date, nil, nil, sort
        )
      campaigns_stats = ActiveSupport::JSON.decode(response)

      ga_data['table_data'] = get_campaign_data(campaigns_stats)
      ga_data['totals'] = get_totals_data(campaigns_stats)

      ga_data
    end

    private

    def init(auth_client)
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
    end

    def common_utils
      @_common_utils ||= GoogleAnalytics::CommonUtils.new
    end

    def get_campaign_data(campaign_stats)
      return unless campaign_stats && campaign_stats['rows']
      campaign_stats['rows'].map do |row|
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
        sessions: campaign_stats['rows'].sum { |x| x[1].to_i },
        new_users: campaign_stats['rows'].sum { |x| x[3].to_i }
      }
    end
  end
end
