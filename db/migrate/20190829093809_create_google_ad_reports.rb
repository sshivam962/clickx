class CreateGoogleAdReports < ActiveRecord::Migration[5.1]
  def change
    create_table :google_ad_reports do |t|
      t.integer :impressions
      t.integer :interactions
      t.float :interaction_rate
      t.float :avg_cost
      t.float :cost
      t.float :conversion

      t.date "report_date", null: false

      t.references :business, index: true
      t.timestamps null: false
    end
  end
end
