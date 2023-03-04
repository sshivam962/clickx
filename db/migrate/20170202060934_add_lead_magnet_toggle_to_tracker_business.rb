class AddLeadMagnetToggleToTrackerBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_websites, :lead_magnet_enabled, :boolean, default: false
  end
end
