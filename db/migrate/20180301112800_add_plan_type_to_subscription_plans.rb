class AddPlanTypeToSubscriptionPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :subscription_plans, :plan_type, :integer, default: 0
  end
end
