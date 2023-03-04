class AddNameToEmbeddableContactFormFields < ActiveRecord::Migration[5.1]
  def change
    add_column :embeddable_contact_form_fields, :name, :string
    add_column :embeddable_contact_form_fields, :name_slug, :string
  end
end
