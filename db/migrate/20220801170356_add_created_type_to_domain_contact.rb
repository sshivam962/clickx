class AddCreatedTypeToDomainContact < ActiveRecord::Migration[5.2]
  def change
    add_column :domain_contacts, :created_type, :integer, default: 0
  end
end
