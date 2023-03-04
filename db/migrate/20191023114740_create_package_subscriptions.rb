class CreatePackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :package_subscriptions do |t|
      t.string :account_id
      t.string :plan_id
      t.integer :amount, default: 0
      t.string :currency, default: 'usd'
      t.string :customer
      t.string :interval
      t.string :status
      t.integer :billing_category
      t.jsonb :metadata
      t.string :package_name

      t.integer :agency_id

      t.timestamps
    end
  end
end
