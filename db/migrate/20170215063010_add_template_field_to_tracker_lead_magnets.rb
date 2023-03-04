class AddTemplateFieldToTrackerLeadMagnets < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnets, :template, :text
  end
end
