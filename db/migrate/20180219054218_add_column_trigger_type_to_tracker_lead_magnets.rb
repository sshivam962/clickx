class AddColumnTriggerTypeToTrackerLeadMagnets < ActiveRecord::Migration[5.1]
  def change
    add_column :tracker_lead_magnets, :trigger_type, :integer, default: 0
  end
end
