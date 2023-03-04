# frozen_string_literal: true

module Businesses
  class Intelligence
    attr_accessor :business
    def initialize(business)
      @business = business
    end

    def top_10_keywords
      query = <<~SQL
              SELECT * FROM (
        SELECT DISTINCT on(keywords.id)
        keywords.name,
        keyword_rankings.google_rank,
        keyword_rankings.search_volume
        FROM keywords
        INNER JOIN keyword_rankings ON keyword_rankings.keyword_id = keywords.id
        WHERE keywords.business_id = #{business.id}
        AND keywords.type in ('Keyword')
        AND keywords.deleted_at IS NULL
        AND keyword_rankings.rank_date >= '#{1.month.ago.to_date}'
        AND keyword_rankings.rank_date < '#{Time.zone.today}'
        AND keyword_rankings.google_rank IS NOT NULL
        ORDER BY keywords.id, keyword_rankings.google_rank
        )
        AS selected
        WHERE cast("search_volume" as double precision) >= 300
        ORDER BY "google_rank","search_volume"
        LIMIT 10
        SQL
      ActiveRecord::Base.connection.execute(query).to_a
    end

    def best_performing_ads
      return [] unless business.google_ads_service?
      date_range = format('%s,%s',
                          Time.zone.parse((Date.current - 30).to_s).strftime('%Y%m%d'),
                          Time.zone.parse((Date.current - 1).to_s).strftime('%Y%m%d'))
      report_utils = Adwords::Adword.new(business, business.adword_client_id, 'ppc').report_utils
      query = format('SELECT Headline,
              AdGroupName,
              AdType,
              CampaignName,
              Clicks,
              Impressions,
              Engagements,
              DisplayUrl,
              Status,
              Cost,
              Connversions,
              AverageCost,
              Ctr
      FROM AD_PERFORMANCE_REPORT
      DURING %s', date_range)
      CSV.parse(report_utils.download_report_with_awql(query, 'CSV'),
                headers: true,
                skip_lines: /AD_PERFORMANCE_REPORT/)
         .sort_by { |hash| -hash['Impressions'].to_i }
         .reject { |hash| hash['Ad'] == 'Total' }
         .take(10)
         .as_json
         .map(&:to_h)
    rescue AdwordsApi::Errors::ReportXmlError, SocketError, AdsCommon::Errors::AuthError
      []
    end

    def google_analytics
      return {} if business.ga_sub.blank?
      GoogleAnalytics::Overview.new(business, {}).fetch
    end

    def google_search_console
      return {} if business.sc_sub.blank?
      auth_google_client = GoogleApiAuth.get_google_client(business, Token::SearchConsoleAccessToken)
      GoogleSearchConsole.get_search_console_overview(auth_google_client, start_date, end_date, business.site_url)
    rescue StandardError => error
      {}
    end

    def last_30_days_adwords_ppc_summary
      if business.google_ads_service? && business.adword_campaign_ids.present?
        Adwords::Graph::Summary.from_params(business, {}, type: 'adword')
      else
        { errors: 'Business not yet opted for AdWords.' }
      end
    rescue AdsCommon::Errors::AuthError => e
      {}
    end

    def competitions
      business.competitions
              .where('updated_at < ?', 7.days.ago)
              .map(&:competition_update_job)
      business.competitions
              .select(:id, :name, :business_id, :logo)
              .order(:name)
    end

    def backlinks
      business.backlink_datum&.summary
    end

    def reviews_stars
      zero_star = one_star = two_star = three_star = four_star = five_star = 0
      business.locations.each do |loc|
        loc.reviews.each do |rev|
          case rev.rating
          when 0 then zero_star += 1
          when 1 then one_star += 1
          when 2 then two_star += 1
          when 3 then three_star += 1
          when 4 then four_star += 1
          when 5 then five_star += 1
          end
        end
      end
      {
        '0star' => zero_star, '1star' => one_star, '2star' => two_star,
        '3star' => three_star, '4star' => four_star, '5star' => five_star
      }
    end

    def datewise_rankings
      KeywordRanking.send('all_time_data', business).to_json
    end

    def call_analytics
      if business.call_analytics_service? && business.call_analytics_id.present?
        Marchex.call_marchex_api([
          business.call_analytics_id,
          {
            extended: true,
            start: start_date,
            end: end_date
          }
        ], 'call.search')
      else
        { errors: 'Business not yet opted for call analytics.' }
      end
    rescue Marchex::Error
      []
    end

    def all
      {
        best_performing_ads: best_performing_ads,
        top_10_keywords: top_10_keywords,
        last_30_days_google_analytics: google_analytics,
        last_30_days_google_search_console: google_search_console,
        last_30_days_adwords_ppc_summary: last_30_days_adwords_ppc_summary,
        last_30_days_business_competitiors: competitions.as_json,
        last_30_days_backlinks: backlinks,
        reviews_stars: reviews_stars,
        datewise_rankings: datewise_rankings,
        last_30_days_call_analytics: call_analytics
      }
    end

    def cache
      if business.intelligence_cache.nil?
        business.create_intelligence_cache(all)
      else
        business.intelligence_cache.update_attributes(all)
      end
    end

    def start_date
      Time.zone.today - 30.days
    end

    def end_date
      Time.zone.today
    end
  end
end
