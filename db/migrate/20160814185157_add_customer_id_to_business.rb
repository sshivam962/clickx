class AddCustomerIdToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :customer_id, :string
  end
end
