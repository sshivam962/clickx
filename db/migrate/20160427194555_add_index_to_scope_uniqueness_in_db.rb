class AddIndexToScopeUniquenessInDb < ActiveRecord::Migration[4.2]
  def change
    add_index :reviews, [ :location_id, :unique_hash ], unique: true
  end
end
