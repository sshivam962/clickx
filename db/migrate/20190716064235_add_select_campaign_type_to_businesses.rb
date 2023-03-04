class AddSelectCampaignTypeToBusinesses < ActiveRecord::Migration[5.1]
  def up
    add_column :businesses, :automate_adword_campaign, :boolean, default: true
    add_column :businesses, :automate_display_campaign, :boolean, default: true
    add_column :businesses, :automate_video_campaign, :boolean, default: true

    retargeting_disconnected_businesses = []
    Business.update_all(
      automate_adword_campaign: false, automate_display_campaign: false,
      automate_video_campaign: false
    )
  end

  def down
    remove_column :businesses, :automate_adword_campaign
    remove_column :businesses, :automate_display_campaign
    remove_column :businesses, :automate_video_campaign
  end
end
