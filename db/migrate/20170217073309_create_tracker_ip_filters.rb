class CreateTrackerIpFilters < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_ip_filters do |t|
      t.inet :ip
      t.string :name
      t.references :tracker_website, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
