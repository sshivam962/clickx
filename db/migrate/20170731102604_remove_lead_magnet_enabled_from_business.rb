class RemoveLeadMagnetEnabledFromBusiness < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :lead_magnet_enabled, :boolean
  end
end
