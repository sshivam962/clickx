class AddColumnCtaTemplateToTrackerLeadMagnets < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_lead_magnets, :cta_template, :string
  end
end
