class RemovePopulateWithDefaultValuesFromEmbeddableContactForm < ActiveRecord::Migration[5.1]
  def change
    remove_column :embeddable_contact_forms, :populate_with_default_values
  end
end
