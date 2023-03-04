class AddVideoCampaignFields < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :video_service, :boolean, default: false
    add_column :businesses, :video_client_id, :string
    add_column :businesses, :video_campaign_ids, :string, array: true, default: []
    add_column :businesses, :video_cost_markup, :float, default: 0
    add_column :businesses, :video_budget, :float, default: 0
  end
end
