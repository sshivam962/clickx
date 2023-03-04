class AddNewFieldsToTrackerMagnets < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnets, :gift, :string
    add_column :tracker_lead_magnets, :image_button, :jsonb
    add_column :tracker_lead_magnets, :text_button, :jsonb
    add_column :tracker_lead_magnets, :plain_button, :jsonb
    add_column :tracker_lead_magnets, :bar_button, :jsonb
    add_column :tracker_lead_magnets, :leadbox, :jsonb
  end
end
