class AddOnetimeChargeToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :onetime_charge, :boolean, default: true
  end
end
