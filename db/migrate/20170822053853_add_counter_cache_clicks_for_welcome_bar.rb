class AddCounterCacheClicksForWelcomeBar < ActiveRecord::Migration[4.2]
  def change
    add_column :hello_bars, :clicks_count, :integer, default: 0
  end
end
