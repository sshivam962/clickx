class RemoveKeywordRankingRawResults < ActiveRecord::Migration[4.2]
  def change
  	drop_table :keyword_ranking_raw_results
  end
end
