class AddDeletedAtToTrackerLeadMagnet < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnets, :deleted_at, :datetime
    add_index :tracker_lead_magnets, :deleted_at
  end
end
