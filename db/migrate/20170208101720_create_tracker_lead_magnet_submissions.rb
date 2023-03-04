class CreateTrackerLeadMagnetSubmissions < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_lead_magnet_submissions do |t|
      t.string :email
      t.references :tracker_website, index: true, foreign_key: true
      t.references :business, index: true, foreign_key: true
      t.references :tracker_lead_magnet, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
