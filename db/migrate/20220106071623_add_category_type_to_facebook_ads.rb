class AddCategoryTypeToFacebookAds < ActiveRecord::Migration[5.1]
  def change
    add_column :facebook_ads, :category_type, :string, default: 'FacebookAds'
  end
end
