class AddCampaignIdsToFbAdAccount < ActiveRecord::Migration[5.1]
  def change
    add_column :fb_ad_accounts, :campaign_ids, :string, default: [], array: true
  end
end
