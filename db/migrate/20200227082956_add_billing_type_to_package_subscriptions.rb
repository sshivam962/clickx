class AddBillingTypeToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def up
    add_column :package_subscriptions, :billing_type, :integer
    PackageSubscription.update_all(billing_type: 'stripe')
  end

  def down
    remove_column :package_subscriptions, :billing_type
  end
end
