class AddCampaignToTrackerContact < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts, :campaign, :string
  end
end
