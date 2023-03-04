class AddLeadServiceToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :leads_service, :boolean, default: false
    add_column :businesses, :unbounce_ids,  :string, array: true
    add_column :businesses, :wufoo_ids,     :boolean, array: true
  end
end
