# frozen_string_literal: true

module Businesses
  module Reports
    class SeoService

      attr_accessor :business, :start_date, :end_date

      def initialize(business, start_date, end_date)
        @business = business
        @start_date = start_date
        @end_date = end_date
      end

      def self.fetch(business, start_date, end_date)
        new(business, start_date, end_date).fetch
      end

      def fetch
        result = {}
        begin
          result[:data] = if business.semrush_project_id.present?
            business.semrush_keywords.with_ranking.order(rank: :asc).first(10)
          else
            ActiveRecord::Base.connection.execute(query).first(10)
          end
          result[:data] = nil if result[:data].count < 5
        rescue StandardError
          result[:data] = nil
        end
        result
      end

      private

      def query
        keywords = business.keywords.select(:id)
        serpurl = 'https://www.google.com/search?gws_rd=ssl,cr&pws=0&uule=w+CAIQICISQ2hnbywgSWxsaW5vaXMsIFVT&num=100&q='
        google_change = 'google_change'
        q =
          <<~CODE
            SELECT DISTINCT on(keyword_rankings.keyword_id)
            keywords.name AS name,
            keyword_rankings.keyword_id AS id,
            keyword_rankings.google_rank AS googleRanking,
            keyword_rankings.#{google_change} AS google_ranking_change,
            keyword_rankings.google_url AS googleRankingUrl,
            keyword_rankings.created_at AS lastGoogleRankingDate,
            keyword_rankings.search_volume AS searchVolume,
            keyword_rankings.cpc, keyword_rankings.rank_date,
            '#{serpurl}'||replace(keywords.name, ' ', '+') AS googleSerpUrl
            from keywords, keyword_rankings
            WHERE keywords.id = keyword_rankings.keyword_id
            AND keyword_rankings.rank_date > '#{start_date}'
            AND keyword_rankings.rank_date < '#{end_date}'
            AND keywords.deleted_at IS NULL
            AND keyword_id in (#{keywords.to_sql})
            AND google_rank IS NOT NULL
            AND type in ('Keyword')
            order by keyword_rankings.keyword_id, rank_date desc
          CODE
        "select * from (#{q}) as selected order by googleranking asc"
      end
    end
  end
end
