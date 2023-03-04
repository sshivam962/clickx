class AddUserReferencesToAdminPaymentLinks < ActiveRecord::Migration[5.1]
  def change
    add_reference :admin_payment_links, :user, foreign_key: true
  end
end
