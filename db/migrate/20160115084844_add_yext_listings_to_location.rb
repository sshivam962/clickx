class AddYextListingsToLocation < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :yext_listings, :json, default: {}, null: false
  end
end
