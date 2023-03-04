class ChangeColumnTypeOfCtaTemplate < ActiveRecord::Migration[4.2]
  def change
    remove_column :tracker_lead_magnets, :cta_template
    add_column :tracker_lead_magnets, :cta_template, :text
  end
end
