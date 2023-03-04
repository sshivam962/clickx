class SetupCustomPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :custom_package_info, :jsonb
    add_column :package_subscriptions, :custom, :boolean
    add_column :package_subscriptions, :custom_package_id, :integer
  end
end
