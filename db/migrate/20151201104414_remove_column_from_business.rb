class RemoveColumnFromBusiness < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :adword_cost_markup, :float
    add_column :businesses, :adword_cost_markup, :float , :default => 0
  end
end
