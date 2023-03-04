class AddPackageTypeToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def up
    add_column :package_subscriptions, :package_type, :integer

    PackageSubscription.find_each do |package|
      package.update(package_type: find_package_type(package))
    end

    remove_column :package_subscriptions, :custom
  end

  def down
    add_column :package_subscriptions, :custom, :boolean

    PackageSubscription.custom.update(custom: true)

    remove_column :package_subscriptions, :package_type
  end

  private

  def find_package_type(package)
    PackageSubscription.package_types.keys.detect do |package_type|
      package.package_name.include? package_type
    end
  end
end
