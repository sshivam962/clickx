class AddCancelFieldsToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :canceled_at, :datetime
    add_column :package_subscriptions, :cancel_at, :datetime
  end
end
