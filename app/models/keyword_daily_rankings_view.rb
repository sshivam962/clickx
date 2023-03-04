# frozen_string_literal: true

class KeywordDailyRankingsView < ApplicationRecord
  self.table_name = 'keyword_daily_rankings_view'
  self.primary_key = :date

  def as_json
    super.except('current_shard')
  end

  def read_only?
    true
  end

  def self.refresh
    ActiveRecord::Base.connection.execute("DROP MATERIALIZED VIEW IF EXISTS keyword_daily_rankings_view")
    ActiveRecord::Base.connection.execute <<~SQL
          CREATE MATERIALIZED VIEW keyword_daily_rankings_view AS
          SELECT keyword_rankings.google_rank AS rank,
                keyword_rankings_last_day_of_month.date::date as date,
                keyword_rankings_last_day_of_month.last_rank_date,
                keyword_rankings_last_day_of_month.business_id,
                keyword_rankings_last_day_of_month.keyword_id FROM
                (
            SELECT max(rank_date) AS last_rank_date,
                keyword_id,
                keywords.business_id, 
                date_trunc('day', rank_date) AS date
            FROM keyword_rankings
            INNER JOIN keywords ON
            keyword_rankings.keyword_id = keywords.id 
            GROUP BY date_trunc('day', rank_date), keyword_id, keywords.business_id
                ) keyword_rankings_last_day_of_month
          INNER JOIN keyword_rankings on
          keyword_rankings.rank_date = keyword_rankings_last_day_of_month.last_rank_date AND
          keyword_rankings.keyword_id = keyword_rankings_last_day_of_month.keyword_id
      SQL
  end
end
