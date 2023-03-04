class AddDeletedAtToPaymentLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_links, :deleted_at, :datetime
    add_index :payment_links, :deleted_at
  end
end
