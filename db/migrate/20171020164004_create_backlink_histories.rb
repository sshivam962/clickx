class CreateBacklinkHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :backlink_histories do |t|
      t.integer :total, default: 0
      t.integer :gained, default: 0
      t.integer :lost, default: 0
      t.date :tracked_date, null: false
      t.integer :business_id

      t.timestamps null: false
    end
  end
end
