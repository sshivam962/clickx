class ChangePaymentLinkIdColumnTypeToString < ActiveRecord::Migration[5.1]
  def change
    change_column :payment_link_plans, :payment_link_id, :string
  end
end
