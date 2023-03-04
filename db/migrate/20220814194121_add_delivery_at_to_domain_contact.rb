class AddDeliveryAtToDomainContact < ActiveRecord::Migration[5.2]
  def change
    add_column :domain_contacts, :delivery_at, :datetime
  end
end
