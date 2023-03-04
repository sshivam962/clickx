class AddBusinessIdToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :business_id, :bigint
  end
end
