class AddStripeCustomerIdToPaymentLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_links, :stripe_customer_id, :string
  end
end
