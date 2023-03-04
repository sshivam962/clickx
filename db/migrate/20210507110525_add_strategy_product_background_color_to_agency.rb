class AddStrategyProductBackgroundColorToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :strategy_product_background_color, :string, default: "#007BBE"
  end
end
