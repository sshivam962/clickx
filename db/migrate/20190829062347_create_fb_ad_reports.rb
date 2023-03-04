class CreateFbAdReports < ActiveRecord::Migration[5.1]
  def change
    create_table :fb_ad_reports do |t|
      t.integer :clicks
      t.integer :inline_link_clicks
      t.integer :impressions
      t.float :ctr
      t.float :cpc
      t.float :spend
      t.float :reach
      t.float :frequency
      t.float :conversion

      t.date "report_date", null: false

      t.references :business, index: true
      t.timestamps null: false
    end
  end
end
