class UpdateKeywordIndexes < ActiveRecord::Migration[4.2]
  def change
    remove_index :keyword_rankings, :business_keyword_id
    remove_index :keyword_rankings, name: 'idx_google_rank_combination'
    add_index :keyword_rankings, [:keyword_id, :google_rank, :rank_date], name: 'idx_google_rank_combination'
  end
end
