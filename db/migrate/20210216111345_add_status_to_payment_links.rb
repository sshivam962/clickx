class AddStatusToPaymentLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_links, :status, :integer, default: 0
  end
end
