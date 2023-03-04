class ChangePaymentLinkIdColumnTypeToUuid < ActiveRecord::Migration[5.1]
  def change
    remove_column :payment_link_plans, :payment_link_id, :string
    add_column :payment_link_plans, :payment_link_id, :uuid
  end
end
