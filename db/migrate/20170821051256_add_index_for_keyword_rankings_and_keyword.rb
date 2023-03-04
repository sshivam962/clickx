class AddIndexForKeywordRankingsAndKeyword < ActiveRecord::Migration[4.2]
  def change
    add_index :keywords, :business_id
    add_index :keyword_rankings, :keyword_id
  end
end
