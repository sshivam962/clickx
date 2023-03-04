class AddKeywordIdToKeywordRankings < ActiveRecord::Migration[4.2]
  def change
    add_column :keyword_rankings, :keyword_id, :integer, index: true
  end
end
