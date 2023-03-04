class AddCustomerIdToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :customer_id, :string
  end
end
