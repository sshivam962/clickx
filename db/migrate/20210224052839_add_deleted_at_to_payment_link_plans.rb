class AddDeletedAtToPaymentLinkPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_link_plans, :deleted_at, :datetime
    add_index :payment_link_plans, :deleted_at
  end
end
