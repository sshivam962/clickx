class AddPackageIdToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def up
    add_column :package_subscriptions, :package_id, :bigint
    add_column :package_subscriptions, :package_class, :string

    Setting.missing_package_subscriptions = []
    PackageSubscription.find_each do |subscription|
      package =
        case subscription.package_type
        when 'bundle'
          BundlePackage.find_by(key: subscription.package_name)
        when 'addons'
          Package.includes(:plans).find_by(
            plans: { package_name: subscription.package_name }
          )
        when 'custom'
          CustomPackage.find(subscription.custom_package_id)
        when 'business_signup'
          Internal::Package.find_by key: subscription.package_type
        else
          Package.find_by(key: subscription.package_type)
        end

      if package
        subscription.update(
          package_class: package.class.name,
          package_id: package.id
        )
      else
        Setting.missing_package_subscriptions =
          Setting.missing_package_subscriptions.push(subscription.id)
      end
    end
  end

  def down
    remove_column :package_subscriptions, :package_id
    remove_column :package_subscriptions, :package_class
  end
end
