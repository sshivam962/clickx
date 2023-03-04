class AddColumnPopupImageToTrackerLeadMagnetTemplates < ActiveRecord::Migration[5.1]
  def change
    add_column :tracker_lead_magnet_templates, :popup_image, :jsonb
  end
end
