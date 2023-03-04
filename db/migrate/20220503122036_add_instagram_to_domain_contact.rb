class AddInstagramToDomainContact < ActiveRecord::Migration[5.2]
  def change
    add_column :domain_contacts, :instagram, :string
  end
end
