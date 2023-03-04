# frozen_string_literal: true

module Businesses
  class TagKeywords
    SERPURL = 'https://www.google.com/search?gws_rd=ssl,cr&pws=0&uule=w+CAIQICISQ2hnbywgSWxsaW5vaXMsIFVT&num=100&q='

    def self.fetch(business, params = {})
      new(business, params).fetch
    end

    def initialize(business, params = {})
      @business = business
      @params = params
    end

    def fetch
      query = "select * from (#{subquery}) AS selected #{order_query} #{pagination_query}"
      data = ActiveRecord::Base.connection.execute(query).as_json
      data.each do |keyword_data|
        competitors_rank = Keywords::CompetitorsRank.new(keyword_data['name'], business).fetch
        keyword_data.merge!('competitors_rank' => competitors_rank)
      end
      data
    end

    private

    attr_reader :business, :params

    def google_change_field
      return "#{time_string}_google_change" if valid_time_string?
      'google_change'
    end

    def time_string
      params[:time_string]
    end

    VALID_TIME_STRINGS = %w[all_time this_month last_30_days last_sevendays].freeze

    def valid_time_string?
      VALID_TIME_STRINGS.include?(time_string)
    end

    def subquery
      %{SELECT DISTINCT ON(keywords.id)
        keywords.name AS name,
        keywords.locale AS locale,
        keywords.city AS city,
        keywords.kdi AS kdi,
        keywords.id as id,
        keywords.active as active,
        keyword_rankings.google_rank AS \"googleRanking\",
        keyword_rankings.#{google_change_field} AS \"google_ranking_change\",
        keyword_rankings.google_url AS \"googleRankingUrl\",
        keyword_rankings.created_at AS \"lastGoogleRankingDate\",
        CAST(keyword_rankings.search_volume AS INT) AS \"searchVolume\",
        keyword_rankings.cpc, keyword_rankings.rank_date,
        '#{SERPURL}'||replace(keywords.name, ' ', '+') AS \"googleSerpUrl\"
        from keywords
        INNER JOIN taggables ON keywords.id = taggables.keyword_id
        LEFT JOIN keyword_rankings ON keywords.id = keyword_rankings.keyword_id
        WHERE keywords.deleted_at IS NULL
        AND keywords.type IN ('Keyword')
        AND keywords.business_id = #{business.id}
        AND taggables.keyword_tag_id = #{@params[:tag_id]}
        AND keywords.active = true
        AND  keyword_rankings.rank_date > '#{Date.current - 2.months}'
        ORDER BY keywords.id, rank_date DESC}
    end

    def order_query
      return 'order by google_ranking_change ASC NULLS LAST' unless params[:sort]
      rank_order = params[:sort_order] == 'true' ? 'DESC NULLS LAST' : 'ASC NULLS LAST'
      "order by \"#{params[:sort]}\" #{rank_order}"
    end

    def query_keywords
      query = business.keywords.select(:id)
      query = query.where(keyword_tag_id: params[:tag_id]) if params[:tag_id]
      query = query.search(params[:search]) if params[:search]
      query
    end

    def keywords
      @_keywords ||= query_keywords
    end

    def pagination_query
      "LIMIT #{params[:limit] || 10} OFFSET #{params[:offset] || 0}"
    end

    def cache_key
      "#{business.id}/#{params.map { |_k, v| v }.join}/keyword_ranks"
    end
  end
end
