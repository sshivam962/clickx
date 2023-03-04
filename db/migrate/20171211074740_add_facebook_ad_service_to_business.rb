class AddFacebookAdServiceToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :facebook_ad_service, :boolean, default: :false
  end
end
