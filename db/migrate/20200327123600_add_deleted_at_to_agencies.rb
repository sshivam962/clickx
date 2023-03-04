class AddDeletedAtToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :deleted_at, :datetime

    add_index :agencies, :deleted_at
  end
end
