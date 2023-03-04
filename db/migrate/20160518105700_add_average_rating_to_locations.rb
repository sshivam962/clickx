class AddAverageRatingToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :average_rating, :float
  end
end
