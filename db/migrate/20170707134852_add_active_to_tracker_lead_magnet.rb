class AddActiveToTrackerLeadMagnet < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnets, :active, :boolean, default: true
  end
end
