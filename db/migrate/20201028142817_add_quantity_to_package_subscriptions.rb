class AddQuantityToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :quantity, :integer, default: 1
  end
end
