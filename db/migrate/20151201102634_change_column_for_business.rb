class ChangeColumnForBusiness < ActiveRecord::Migration[4.2]
  def change
    change_column :businesses, :adword_cost_markup, :float, :default => 0
  end
end
