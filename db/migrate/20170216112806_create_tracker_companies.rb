class CreateTrackerCompanies < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_companies do |t|
      t.string :name
      t.string :provider_id
      t.string :provider
      t.text :description
      t.text :location
      t.string :domain
      t.string :time_zone
      t.jsonb :provider_raw_data
      t.string :tags, array: true
      t.string :company_type
      t.string :logo

      t.timestamps null: false
    end
  end
end
