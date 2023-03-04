class AddFieldsForGoogleAdsToBusinesses < ActiveRecord::Migration[5.2]
  def change
    add_column :businesses, :google_ads_customer_client_id, :string
    add_column :businesses, :google_ads_login_customer_id, :string
  end
end
