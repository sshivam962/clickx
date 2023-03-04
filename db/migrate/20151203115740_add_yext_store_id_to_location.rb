class AddYextStoreIdToLocation < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :yext_store_id, :string
  end
end
