class AddCoordinatesToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :coordinates, :integer, array: true, default: []
  end
end
