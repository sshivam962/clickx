class AddStripeObjectTypeToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :stripe_object_type, :string
  end
end
