class AddSetAsFreeToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :set_as_free, :boolean, default: false
  end
end
