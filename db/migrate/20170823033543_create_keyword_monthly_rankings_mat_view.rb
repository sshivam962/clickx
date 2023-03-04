class CreateKeywordMonthlyRankingsMatView < ActiveRecord::Migration[4.2]
  def up
      execute <<~SQL
          CREATE MATERIALIZED VIEW keyword_monthly_rankings_view AS
          SELECT keyword_rankings.google_rank AS rank,
                keyword_rankings_last_day_of_month.date::date as date,
                keyword_rankings_last_day_of_month.last_rank_date,
                keyword_rankings_last_day_of_month.business_id,
                keyword_rankings_last_day_of_month.keyword_id FROM
                (
            SELECT max(rank_date) AS last_rank_date,
                keyword_id,
                keywords.business_id, 
                date_trunc('month', rank_date) AS date
            FROM keyword_rankings
            INNER JOIN keywords ON
            keyword_rankings.keyword_id = keywords.id 
            GROUP BY date_trunc('month', rank_date), keyword_id, keywords.business_id
                ) keyword_rankings_last_day_of_month
          INNER JOIN keyword_rankings on
          keyword_rankings.rank_date = keyword_rankings_last_day_of_month.last_rank_date AND
          keyword_rankings.keyword_id = keyword_rankings_last_day_of_month.keyword_id
      SQL

      add_index :keyword_monthly_rankings_view, [:date, :keyword_id, :business_id], 
        # unique: true,
        name: :keyword_monthly_rankings_view_cmp_index
      add_index :keyword_monthly_rankings_view, :business_id
  end

  def down
    execute("DROP MATERIALIZED VIEW IF EXISTS keyword_monthly_rankings_view")
  end
end
