class ImplementationDetailsToPaymentLinkSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_link_subscriptions, :implementation_invoice_id, :string
  end
end
