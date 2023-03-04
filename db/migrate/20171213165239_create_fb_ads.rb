class CreateFbAds < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_ads do |t|
      t.integer :ad_id
      t.string :ad_type
      t.integer :fb_adaccount_id

      t.timestamps
    end
  end
end
