class CreateSubscriptionAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_accounts do |t|
      t.string :account_id
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.datetime :canceled_at
      t.boolean :cancel_at_period_end
      t.datetime :ended_at
      t.string :plan_id
      t.string :plan_name
      t.integer :amount, default: 0
      t.string :currency, default: 'usd'
      t.string :interval
      t.integer :interval_count, default: 0
      t.integer :trial_period_days, default: 0
      t.datetime :trial_start
      t.datetime :trial_end
      t.integer :status
      t.integer :billing

      t.integer :business_id

      t.timestamps
    end
  end
end
