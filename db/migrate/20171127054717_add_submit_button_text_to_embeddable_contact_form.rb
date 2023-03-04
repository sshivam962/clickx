class AddSubmitButtonTextToEmbeddableContactForm < ActiveRecord::Migration[5.1]
  def change
    add_column :embeddable_contact_forms, :submit_button_text, :string, default: "Submit"
  end
end
