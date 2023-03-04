class AddUserInfoToPaymentLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :payment_links, :user_name, :string
    add_column :payment_links, :user_email, :string
  end
end
