class AddAdditionalFieldsToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :campaign_info, :text, array: true, default: []
    add_column :leads, :competitor_info, :text, array: true, default: []
    add_column :leads, :next_steps, :text, array: true, default: []
    add_column :leads, :call_notes, :text
  end
end
