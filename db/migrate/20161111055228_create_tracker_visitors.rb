class CreateTrackerVisitors < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_visitors do |t|
      t.integer :visit_count
      t.string :visitor_id
      t.references :business,index: true

      t.timestamps null: false
    end

    add_index :tracker_visitors , :visitor_id
  end
end
