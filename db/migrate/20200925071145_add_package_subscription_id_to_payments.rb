class AddPackageSubscriptionIdToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :package_subscription_id, :bigint
  end
end
