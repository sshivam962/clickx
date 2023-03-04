class CreateSubscriptionPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.string :plan_id
      t.string :currency
      t.string :interval
      t.integer :amount, default: 0
      t.integer :interval_count, default: 0
      t.string :statement_descriptor
      t.integer :trial_period_days, default: 0
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
