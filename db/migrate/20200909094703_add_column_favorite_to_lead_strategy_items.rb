class AddColumnFavoriteToLeadStrategyItems < ActiveRecord::Migration[5.1]
  def change
    add_column :lead_strategy_items, :favorite, :boolean, default: false
  end
end
