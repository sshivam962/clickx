class AddUnbounceAndWufooToggleToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :wufoo_enabled,:boolean, default: false
    add_column :businesses, :unbounce_enabled,:boolean, default: false
  end
end
