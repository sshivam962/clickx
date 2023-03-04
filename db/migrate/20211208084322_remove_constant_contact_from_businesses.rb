class RemoveConstantContactFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :constant_contact_integration, :jsonb
  end
end
