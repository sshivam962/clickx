class DropTableFbAds < ActiveRecord::Migration[5.1]
  def up
    drop_table :fb_ads
  end

  def down
    create_table "fb_ads" do |t|
      t.integer "ad_id"
      t.string "ad_type"
      t.integer "fb_adaccount_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
