class AddPublicToSubscriptionPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :subscription_plans, :public, :boolean, default: false
  end
end
