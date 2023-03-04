# frozen_string_literal: true

module Businesses
  class KeywordRanks
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
      # Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      data = ActiveRecord::Base.connection.execute(query).as_json
      # end
      data.each do |keyword_data|
        # competitors_rank = Keywords::CompetitorsRank.new(keyword_data['name'], business).fetch
        # keyword_data.merge!('competitors_rank' => competitors_rank,
        #                     'tags' => keyword_tags(keyword_data["id"]))
        keyword_data.merge!('tags' => keyword_tags(keyword_data["id"]))
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
        LEFT JOIN keyword_rankings ON keywords.id = keyword_rankings.keyword_id
        AND keyword_rankings.rank_date > '#{Date.current - 2.months}'
        WHERE keywords.business_id = #{business.id}
        AND keywords.type in ('Keyword')
        AND keywords.deleted_at IS NULL
        AND keywords.id in (#{keywords.to_sql})
        AND keywords.active = true
        ORDER BY keywords.id, rank_date DESC}
    end

    def order_query
      return 'order by google_ranking_change ASC NULLS LAST' unless params[:sort]
      rank_order = params[:sort_order] == 'true' ? 'DESC NULLS LAST' : 'ASC NULLS LAST'
      "order by \"#{params[:sort]}\" #{rank_order}"
    end

    def query_keywords
      query = business.keywords.select(:id)
      query = query_tag_ids(query)
      query = query.search(params[:search]) if params[:search]
      query = query_location(query)
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

    def query_tag_ids(query)
      if params[:tag_ids].present?
        tag_ids = JSON.parse(params[:tag_ids])
        if !tag_ids.blank?
          query = query.left_joins(:taggables).where("taggables.keyword_tag_id IN (?)", tag_ids)
        end
      end
      query
    end

    def query_location(query)
      if params[:location]
        location = JSON.parse(params[:location])
        if !location.blank?
          query = query.where("keywords.city IN (?)", location)
        end
      end
      query
    end

    def keyword_tags(keyword_id)
      query = "SELECT DISTINCT ON(keywords.id)
      keyword_tags.id AS id,
      keyword_tags.name AS name,
      keyword_tags.color AS color
      from keywords
      INNER JOIN taggables on taggables.keyword_id = #{keyword_id}
      INNER JOIN keyword_tags on taggables.keyword_tag_id = keyword_tags.id
      WHERE keywords.business_id = #{business.id}
      AND keywords.type in ('Keyword')
      AND keywords.deleted_at IS NULL
      AND keywords.id in (#{keywords.to_sql})
      AND keywords.active = true"
      ActiveRecord::Base.connection.execute(query).to_a.uniq
    end
  end
end
