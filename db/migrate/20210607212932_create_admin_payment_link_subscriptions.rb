class CreateAdminPaymentLinkSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_payment_link_subscriptions do |t|
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
      t.string :implementation_invoice_id
      t.references :admin_payment_link_plan, index: {:name => "index_admin_payment_link_plan_id"}

      t.timestamps
    end
  end
end
