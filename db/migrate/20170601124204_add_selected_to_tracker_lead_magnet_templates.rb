class AddSelectedToTrackerLeadMagnetTemplates < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnet_templates, :selected, :string
  end
end
