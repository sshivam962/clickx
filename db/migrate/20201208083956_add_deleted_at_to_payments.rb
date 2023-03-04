class AddDeletedAtToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :deleted_at, :datetime
  end
end
