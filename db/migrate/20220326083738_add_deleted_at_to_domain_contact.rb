class AddDeletedAtToDomainContact < ActiveRecord::Migration[5.1]
  def change
    add_column :domain_contacts, :deleted_at, :datetime
    add_index :domain_contacts, :deleted_at
  end
end
