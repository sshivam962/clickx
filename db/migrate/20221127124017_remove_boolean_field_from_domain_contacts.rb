class RemoveBooleanFieldFromDomainContacts < ActiveRecord::Migration[5.2]
  def change
    remove_column :domain_contacts, :boolean, :boolean, default: false
  end
end
