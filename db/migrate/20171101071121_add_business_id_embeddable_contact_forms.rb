class AddBusinessIdEmbeddableContactForms < ActiveRecord::Migration[5.1]
  def change
    add_column :embeddable_contact_forms, :business_id, :integer 
    add_index :embeddable_contact_forms, :business_id
  end
end
