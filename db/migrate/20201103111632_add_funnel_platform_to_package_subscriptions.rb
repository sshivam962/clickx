class AddFunnelPlatformToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :funnel_platform, :string
  end
end
