class AddDisabledToPaymentLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_links, :disabled, :boolean, default: false
  end
end
