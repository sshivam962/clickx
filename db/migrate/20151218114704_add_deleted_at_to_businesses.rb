class AddDeletedAtToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :deleted_at, :datetime
    add_index :businesses, :deleted_at
  end
end
