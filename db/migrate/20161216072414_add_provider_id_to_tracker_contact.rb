class AddProviderIdToTrackerContact < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts , :provider_id, :string
  end
end
