class AddStrategyProductTextColor < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :strategy_product_text_color, :string, default: "#FFF"
  end
end
