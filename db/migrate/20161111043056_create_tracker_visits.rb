class CreateTrackerVisits < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_visits do |t|
      t.string :url
      t.datetime :time
      t.string :title
      t.string :visit_id
      t.string :visitor_id
      # t.references :tracker_visitor
      t.jsonb :utm
      t.jsonb :meta
      t.references :business,index:true

      t.timestamps null: false
    end
    add_index :tracker_visits,:visitor_id
    add_index :tracker_visits,:visit_id
  end
end
