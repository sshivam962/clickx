class RemoveUnbounceFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :unbounce_key, :string
    remove_column :businesses, :unbounce_enabled,:boolean, default: false
    remove_column :businesses, :unbounce_ids, :string, array: true, default: []
  end
end
