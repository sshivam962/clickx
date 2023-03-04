class AddHelpTextAndDefaultValueToEmbeddableContactFormFields < ActiveRecord::Migration[5.1]
  def change
    add_column :embeddable_contact_form_fields, :default_value, :string
    add_column :embeddable_contact_form_fields, :help_text, :string
  end
end
