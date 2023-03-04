class RemoveActivecampaignColumnsFromBusiness < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :activecampaign_domain, :string
    remove_column :businesses, :activecampaign_api_key, :string
  end
end
