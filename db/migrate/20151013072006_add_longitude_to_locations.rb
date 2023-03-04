class AddLongitudeToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :lng, :decimal, {precision: 10, scale: 6}
  end
end
