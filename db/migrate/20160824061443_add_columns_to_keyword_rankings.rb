class AddColumnsToKeywordRankings < ActiveRecord::Migration[4.2]
  def change
    add_column :keyword_rankings, :all_time_google_change, :integer
    add_column :keyword_rankings, :all_time_bing_change, :integer
    add_column :keyword_rankings, :this_month_google_change, :integer
    add_column :keyword_rankings, :this_month_bing_change, :integer
    add_column :keyword_rankings, :last_30_days_google_change, :integer
    add_column :keyword_rankings, :last_30_days_bing_change, :integer
    add_column :keyword_rankings, :last_sevendays_google_change, :integer
    add_column :keyword_rankings, :last_sevendays_bing_change, :integer
  end
end
