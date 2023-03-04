class AddNameUniqueValidationsToAgency < ActiveRecord::Migration[5.1]
  def change
    remove_index :agencies, :name
    add_index :agencies, :name, unique: true
    add_index :agencies, :name_slug, unique: true
  end
end
