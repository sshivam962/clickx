class AddGiftNameToTrackerLeadMagnets < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnets, :gift_name, :string
  end
end
