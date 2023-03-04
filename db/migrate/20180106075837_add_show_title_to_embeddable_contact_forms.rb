class AddShowTitleToEmbeddableContactForms < ActiveRecord::Migration[5.1]
  def change
    add_column :embeddable_contact_forms, :show_title, :boolean, default: true
  end
end
