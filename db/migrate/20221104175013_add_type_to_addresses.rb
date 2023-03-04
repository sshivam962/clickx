class AddTypeToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :type, :string

    Address.update_all(type: 'BillingAddress')

    remove_index :addresses, column: [:addressable_type, :addressable_id], name: 'index_addresses_on_addressable_type_and_addressable_id'

    add_index :addresses, [:addressable_type, :addressable_id, :type], name: 'index_addresses_on_addressable_type_and_addressable_id_and_type'
  end
end
