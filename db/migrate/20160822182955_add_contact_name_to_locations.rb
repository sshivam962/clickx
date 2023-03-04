class AddContactNameToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :contact_name, :string
  end
end
