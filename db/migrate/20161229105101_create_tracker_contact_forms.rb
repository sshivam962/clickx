class CreateTrackerContactForms < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_contact_forms do |t|
      t.string :logo
      t.string :title
      t.text :description
      t.string :button_text
      t.jsonb :inputs
      t.boolean :validate_fields, default: false
      t.jsonb :header
      t.jsonb :button
      t.references :tracker_website, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
