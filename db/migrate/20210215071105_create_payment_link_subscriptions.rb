class CreatePaymentLinkSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_link_subscriptions do |t|
      t.string :account_id
      t.integer :amount, default: 0
      t.string :currency, default: "usd"
      t.string :customer
      t.string :interval
      t.string :status
      t.integer :billing_category
      t.jsonb :metadata
      t.integer :billing_type
      t.integer :quantity, default: 1
      t.datetime :canceled_at
      t.datetime :cancel_at

      t.references :agency
      t.references :lead
      t.references :payment_link_plan
      t.timestamps
    end
  end
end
