# frozen_string_literal: true

module GoogleAnalytics
  class TrafficMetrics
    include GoogleApiAuth

    def initialize(business)
      @business = business
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
    end

    def fetch
      table_data
    end

    private

    attr_reader :business

    def auth_client
      @_auth_google_client ||=
        get_google_client(business, Token::AnalyticsAccessToken)
    end

    def start_date
      @start_date ||=
        (Time.zone.today - 30.days).to_date.strftime('%Y-%m-%d')
    end

    def end_date
      @_end_date ||=
        Time.zone.today.to_date.strftime('%Y-%m-%d')
    end

    def profile_id
      business.google_analytics_id
    end

    def common_utils
      @_common_utils ||= GoogleAnalytics::CommonUtils.new
    end

    def table_data
      response =
        common_utils.fetch_analytics_data(
          profile_id, 'ga:pagePath', 'ga:sessions',
          @client, {}, start_date, end_date
        )
      JSON.parse(response)['rows']
    end
  end
end
