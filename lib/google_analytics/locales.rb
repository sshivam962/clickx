# frozen_string_literal: true

module GoogleAnalytics
  class Locales
    include GoogleApiAuth

    def initialize(business, params)
      @params = params
      @business = business
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
      @metrics = 'ga:percentNewSessions,ga:sessions,ga:bounceRate,ga:sessionDuration,ga:pageviewsPerSession'
      @dimensions = 'ga:country'
      @sort = '-ga:sessions'
    end

    def fetch
      ga_data = {}
      response = fetch_analytics_data
      site_stats = ActiveSupport::JSON.decode(response)
      # tabular data
      ga_data['table_data'] = get_sites_data(site_stats)
      ga_data
      # TODO: hash as per site stats
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
      params = {
        'ids'        => "ga:#{profile_id}",
        'start-date' => start_date,
        'end-date'   => end_date,
        'dimensions' => @dimensions,
        'metrics'    => @metrics
      }
      params['sort'] = @sort unless @sort.nil?
      # @client.execute(:api_method => @analytics.data.ga.get, :parameters => params)

      ids = "ga:#{profile_id}"
      signature = Digest::SHA1.digest(params.to_s)
      APICache.get(signature, cache: CACHE_DURATION, timeout: 60) do
        @client.get_ga_data(ids, start_date, end_date, @metrics,
                            dimensions: @dimensions, sort: @sort)
      end
    rescue StandardError
      '{}'
    end

    def get_sites_data(site_stats)
      sites = []
      return sites unless site_stats && site_stats['rows']
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
      sites
    end

    def time_form(seconds)
      format = seconds < 3600 ? '%M:%S' : '%H:%M:%S'
      Time.at(seconds).utc.strftime(format)
    end
  end
end
