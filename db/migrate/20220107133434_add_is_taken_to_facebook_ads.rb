class AddIsTakenToFacebookAds < ActiveRecord::Migration[5.1]
  def change
    add_column :facebook_ads, :is_taken, :boolean, default: false
  end
end
