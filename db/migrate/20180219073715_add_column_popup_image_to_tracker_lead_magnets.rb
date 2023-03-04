class AddColumnPopupImageToTrackerLeadMagnets < ActiveRecord::Migration[5.1]
  def change
    add_column :tracker_lead_magnets, :popup_image, :jsonb
  end
end
