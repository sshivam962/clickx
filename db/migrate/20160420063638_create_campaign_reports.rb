class CreateCampaignReports < ActiveRecord::Migration[4.2]
  def change
    create_table :campaign_reports do |t|
      t.integer :impressions
      t.integer :clicks
      t.float :costs
      t.integer :click_conversions
      t.float :post_click_revenue
      t.integer :view_conversions
      t.float :post_view_revenue
      t.string :campaign_id
      t.string :campaign_name
      t.string :campaign_nid
      t.string :campaign_type
      t.integer :conversions
      t.float :revenue
      t.float :ctr
      t.float :cpc
      t.float :conversion_rate
      t.float :cpm
      t.float :adjusted_post_click_revenue
      t.float :adjusted_post_view_revenue
      t.float :adjusted_conversion_revenue

      t.integer :business_id
      t.date :report_date

      t.timestamps null: false
    end
  end
end
