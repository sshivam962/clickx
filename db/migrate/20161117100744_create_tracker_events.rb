class CreateTrackerEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_events do |t|
      t.integer :visit_id
      t.integer :contact_id
      t.string :name
      t.jsonb :properties
      t.timestamp :time

      t.references :business,  index: true
      t.timestamps null: false
    end
  end
end
