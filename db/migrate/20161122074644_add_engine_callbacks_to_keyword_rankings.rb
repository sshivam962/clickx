class AddEngineCallbacksToKeywordRankings < ActiveRecord::Migration[4.2]
  def change
    add_column :keyword_rankings, :google_callback_updated_at, :datetime
    add_column :keyword_rankings, :bing_callback_updated_at, :datetime
  end
end
