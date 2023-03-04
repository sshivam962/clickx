class CreateTrackerWebsites < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_websites do |t|
      t.string :uri
      t.string :description
      t.string :title
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
