class CreateFacebookAds < ActiveRecord::Migration[5.1]
  def change
    create_table :facebook_ads do |t|
      t.string :title
      t.text :description
      
      t.timestamps
    end
  end
end
