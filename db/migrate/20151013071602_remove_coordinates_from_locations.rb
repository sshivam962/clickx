class RemoveCoordinatesFromLocations < ActiveRecord::Migration[4.2]
  def change
    remove_column :locations, :coordinates 
  end
end
