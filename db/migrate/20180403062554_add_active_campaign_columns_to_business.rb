class AddActiveCampaignColumnsToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :activecampaign_domain, :string
    add_column :businesses, :activecampaign_api_key, :string
  end
end
