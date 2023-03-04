class AddCounterCacheForWelcomeBar < ActiveRecord::Migration[4.2]
  def change
    add_column :hello_bars, :submissions_count, :integer, default: 0
    add_column :hello_bars, :impressions_count, :integer, default: 0
  end
end
