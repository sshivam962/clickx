class CreateTrackerLeadMagnets < ActiveRecord::Migration[4.2]
  def change
    create_table :tracker_lead_magnets do |t|
      t.string :name
      t.jsonb :button
      t.jsonb :form
      t.string :image
      t.string :image_link
      t.jsonb :lead_box
      t.string :logo
      t.jsonb :progress
      t.jsonb :title
      t.boolean :has_button
      t.boolean :has_button_color
      t.boolean :has_form
      t.boolean :has_progress_bar
      t.boolean :has_progress_bar
      t.boolean :has_title

      t.references :tracker_website

      t.timestamps null: false
    end
  end
end
