class AddRawDataToKeywordRankings < ActiveRecord::Migration[4.2]
  def change
    add_column :keyword_rankings, :google_raw_data, :json
    add_column :keyword_rankings, :bing_raw_data, :json
  end
end
