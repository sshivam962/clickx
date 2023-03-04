class AddDeletedAtToTrackerContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts, :deleted_at, :datetime
    add_index :tracker_contacts, :deleted_at
  end
end
