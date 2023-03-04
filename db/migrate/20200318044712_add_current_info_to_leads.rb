class AddCurrentInfoToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :current_info, :text
  end
end
