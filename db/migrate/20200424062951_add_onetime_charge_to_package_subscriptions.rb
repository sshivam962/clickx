class AddOnetimeChargeToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :onetime_charge, :float
    add_column :package_subscriptions, :onetime_charge_invoice_id, :string
  end
end
