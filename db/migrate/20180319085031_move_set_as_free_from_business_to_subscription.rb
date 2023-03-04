class MoveSetAsFreeFromBusinessToSubscription < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :set_as_free
    add_column :subscription_accounts, :set_as_free, :boolean, default: false
  end
end
