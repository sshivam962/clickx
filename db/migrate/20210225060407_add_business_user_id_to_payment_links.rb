class AddBusinessUserIdToPaymentLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_links, :business_user_id, :bigint
  end
end
