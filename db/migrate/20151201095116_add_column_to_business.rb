class AddColumnToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :adword_cost_markup, :float
  end
end
