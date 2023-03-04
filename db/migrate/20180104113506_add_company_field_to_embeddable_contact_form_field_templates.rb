class AddCompanyFieldToEmbeddableContactFormFieldTemplates < ActiveRecord::Migration[5.1]
  def up
    template = {
      name: 'Company',
      name_slug: 'company',
      field_type: 'text',
      label: 'Company',
      placeholder: nil,
    }
    EmbeddableContactFormFieldTemplate.create(template)
  end

  def down
    EmbeddableContactFormFieldTemplate.where(name_slug: 'company').destroy_all
  end
end
