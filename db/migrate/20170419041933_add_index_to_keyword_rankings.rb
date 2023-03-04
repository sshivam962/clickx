class AddIndexToKeywordRankings < ActiveRecord::Migration[4.2]
  def change
    add_index :keyword_rankings, [:google_rank, :rank_date, :business_keyword_id], name: 'idx_google_rank_combination'
    add_index :keyword_rankings, [:bing_rank, :rank_date, :business_keyword_id], name: 'idx_bing_rank_combination'
  end
  # VACCUM table to pick up indexes right away
  # execute "VACUUM (ANALYZE, VERBOSE) keyword_rankings"
end
