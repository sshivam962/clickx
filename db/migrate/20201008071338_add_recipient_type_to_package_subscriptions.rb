class AddRecipientTypeToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def up
    add_column :package_subscriptions, :recipient_type, :string

    PackageSubscription.find_each do |sub|
      if sub.business_id.present?
        if sub.package_class.eql?('Internal::Package')
          sub.update(recipient_type: 'smb')
        else
          sub.update(recipient_type: 'client')
        end
      else
        sub.update(recipient_type: 'agency')
      end
    end
  end

  def down
    remove_column :package_subscriptions, :recipient_type
  end
end
