class AddAccountableToSubscriptionAccounts < ActiveRecord::Migration[5.1]
  def up
    add_column :subscription_accounts, :accountable_id, :integer
    add_column :subscription_accounts, :accountable_type, :string

    Subscription::Account.update_all("accountable_id = business_id")
    Subscription::Account.update_all(accountable_type: 'Business')

    remove_column :subscription_accounts, :business_id, :integer
  end

  def down
    add_column :subscription_accounts, :business_id, :integer

    Subscription::Account.update_all("business_id = accountable_id")

    remove_column :subscription_accounts, :accountable_id, :integer
    remove_column :subscription_accounts, :accountable_type, :string
  end
end
