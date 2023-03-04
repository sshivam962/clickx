class CreateTrackerLeadMagnetTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_lead_magnet_templates do |t|
      t.string :name
      t.jsonb :button
      t.jsonb :form
      t.string :image
      t.string :logo
      t.jsonb :title
      t.jsonb :progress
      t.jsonb :leadbox
      t.timestamps null: false
    end
  end
end
