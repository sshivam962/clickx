class AddWebsiteToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :website_service, :boolean, default: false
    add_column :businesses, :website_url, :string 
  end
end
