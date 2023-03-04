class AddAdwordCampaignIdToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :adword_campaign_ids, :string, array: true, default: []
  end
end
