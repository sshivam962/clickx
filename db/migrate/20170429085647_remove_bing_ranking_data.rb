class RemoveBingRankingData < ActiveRecord::Migration[4.2]
  def change
    remove_column :keyword_rankings, :bing_rank,                  :integer
    remove_column :keyword_rankings, :bing_change,                :integer
    remove_column :keyword_rankings, :bing_url,                   :text
    remove_column :keyword_rankings, :all_time_bing_change,       :integer
    remove_column :keyword_rankings, :this_month_bing_change,     :integer
    remove_column :keyword_rankings, :last_30_days_bing_change,   :integer
    remove_column :keyword_rankings, :last_sevendays_bing_change, :integer
    remove_column :keyword_rankings, :bing_callback_updated_at,   :datetime
    remove_column :keyword_rankings, :bing_raw_data,              :json
  end
end
