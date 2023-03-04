class CreateImpressions < ActiveRecord::Migration[4.2]
  def change
    create_table :impressions do |t|
      t.references :impressionable, index: true, polymorphic: true
      t.jsonb :request_hash
      t.inet :ip_address
      t.jsonb :params
      t.references :tracker_visitor, index: true
      t.references :tracker_visit, index: true

      t.timestamps null: false
    end
  end
end
