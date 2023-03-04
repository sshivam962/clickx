class CreateEmbeddableContactFormFieldTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :embeddable_contact_form_field_templates do |t|
      t.string :name
      t.string :name_slug
      t.string :field_type
      t.string :label
      t.string :placeholder
      t.string :answer_options ,array: true, default: []

      t.timestamps
    end
  end
end
