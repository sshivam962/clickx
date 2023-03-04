class AddStatusAndValueToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :value, :integer
    add_column :leads, :status, :integer, default: 0
  end
end
