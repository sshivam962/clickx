class AddSuccessUrlAndMessageToEmbeddableContactForms < ActiveRecord::Migration[5.1]
  def change
    add_column :embeddable_contact_forms, :success_url, :string
    add_column :embeddable_contact_forms, :success_message, :string
  end
end
