class CreateClicks < ActiveRecord::Migration[4.2]
  def change
    create_table :clicks do |t|
      t.references :clickable, polymorphic: true, index: true
      t.jsonb :request_hash
      t.inet :ip_address
      t.jsonb :params
      t.references :tracker_visitor, index: true, foreign_key: true
      t.references :tracker_visit, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
