class RemoveLeadIdFromPaymentLinkSubscriptions < ActiveRecord::Migration[5.1]
  def change
    remove_column :payment_link_subscriptions, :lead_id, :string
  end
end
