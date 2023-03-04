class AddYextInfoToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :yext_info, :json, default: {}
  end
end
