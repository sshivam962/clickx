class CreateSubscriptionSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :subscription_schedules do |t|
      t.string :stripe_id
      t.integer :status
      t.string :stripe_plan
      t.datetime :start_at
      t.jsonb :metadata

      t.references :agency

      t.timestamps
    end
  end
end
