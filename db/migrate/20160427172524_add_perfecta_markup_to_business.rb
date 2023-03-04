class AddPerfectaMarkupToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :perfecta_cost_markup, :float, default: 0.0
  end
end
