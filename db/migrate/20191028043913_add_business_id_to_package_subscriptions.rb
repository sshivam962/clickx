class AddBusinessIdToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :business_id, :integer
  end
end
