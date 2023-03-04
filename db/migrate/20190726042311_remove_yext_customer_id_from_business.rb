class RemoveYextCustomerIdFromBusiness < ActiveRecord::Migration[5.1]
  def change
    remove_column :agencies, :yext_customer_id, :string
  end
end
