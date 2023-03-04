class AddDownPaymentToSignupLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :signup_links, :down_payment, :float
  end
end
