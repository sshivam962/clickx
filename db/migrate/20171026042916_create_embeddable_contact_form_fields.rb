class CreateEmbeddableContactFormFields < ActiveRecord::Migration[5.1]
  def change
    create_table :embeddable_contact_form_fields do |t|
      t.string :field_type
      t.string :label
      t.string :placeholder
      t.integer :position
      t.boolean :required, default: false
      t.string :answer_options, array: true, default: []
      t.references :embeddable_contact_form, index: {name: 'form_index_for_embeddable_form_field'}

      t.timestamps
    end
  end
end
