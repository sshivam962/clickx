# frozen_string_literal: true

module GoogleAnalytics
  class Overview
    include GoogleApiAuth

    def initialize(business, params)
      @business = business
      @params = params
      @client = Google::Apis::AnalyticsV3::AnalyticsService.new
      @client.authorization = auth_client
    end

    def fetch
      graph_option = params[:graph_option] || 'date'
      chart_type = params[:chart_type] || 'default'
      ga_data = {}
      response = common_utils.fetch_analytics_data(
        profile_id, '',
        'ga:sessions,ga:users,ga:pageviews,ga:organicSearches,ga:bounceRate,ga:percentNewSessions,ga:avgPageLoadTime,ga:avgSessionDuration,ga:avgTimeOnPage',
        @client, @params, start_date, end_date, nil, nil, nil
      )

      ga_data['totals'] = ActiveSupport::JSON.decode(response)['totalsForAllResults']
      ga_data['visit_status'] = get_visit_stats
      ga_data['users_data'] = get_users_stats(chart_type, graph_option)
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

    def get_visit_stats
      # direct visits
      response = common_utils.fetch_analytics_data(profile_id,
                                                   'ga:source,ga:hasSocialSourceReferral,ga:medium',
                                                   'ga:sessions', @client, params, start_date,
                                                   end_date, 'ga:medium==referral', nil, nil)
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
      response = common_utils.fetch_analytics_data(profile_id, 'ga:socialNetwork', 'ga:sessions', @client, @params,
                                                   start_date, end_date, nil, nil, nil)
      visit_data = ActiveSupport::JSON.decode(response)['rows']
      visit_data&.delete_if { |i| i[0] == '(not set)' }
      visit_data&.collect { |i| visit_count += i[1].to_i } if visit_data
      social_visits = visit_count
      {
        referral: referral_visits,
        organic: organic_visits,
        direct: direct_visits,
        paid: paid_visits,
        social: social_visits,
        email: email_visits,
        others: other_visits
      }
    end

    def get_users_stats(chart_type, graph_option)
      dimensions = "ga:#{graph_option},ga:year"
      dimensions = "ga:#{graph_option}" if graph_option == 'year' || graph_option == 'date'

      resp = common_utils.fetch_analytics_data(
        profile_id, dimensions,
        'ga:percentNewSessions,ga:sessions,ga:users,ga:bounceRate,ga:avgSessionDuration,ga:pageviewsPerSession',
        @client, params, start_date, end_date, nil, nil, nil
      )
      rows = ActiveSupport::JSON.decode(resp).fetch('rows', [])
      visitor_stats =
        case graph_option
        when 'date'
          common_utils.reset_hash_index_for_date(rows)
        when 'week'
          common_utils.reset_hash_index_for_week(rows)
        when 'month'
          common_utils.reset_hash_index_for_month(rows)
        when 'year'
          common_utils.reset_hash_index_for_year(rows)
        end

      visitor_stats = visitor_stats.sort_by { |k, _v| k }
      rows = {}

      if chart_type == 'rainfall'
        sum = [0, 0, 0, 0, 0, 0]
        visitor_stats.each do |visit|
          sum = sum.zip(visit[1]).map { |x, y| x.to_f + y.to_f }
          rows[visit[0]] = sum
        end
      else
        rows = visitor_stats.to_h
      end

      rows
    end
  end
end
