class RemoveUwantedFieldsFromEmbeddableContactFormFieldTemplates < ActiveRecord::Migration[5.1]
  def up
    EmbeddableContactFormFieldTemplate.where(name_slug: ['gender', 'date_of_birth']).destroy_all
  end

  def down
    gender = {
      name: 'Gender',
      name_slug: 'gender',
      field_type: 'radio',
      label: 'Gender',
      placeholder: nil,
      answer_options: ['Male', 'Female', 'Other']
    }
    dob = {
      name: 'DOB',
      name_slug: 'date_of_birth',
      field_type: 'date',
      label: 'DOB',
      placeholder: nil,
    }
    EmbeddableContactFormFieldTemplate.create(gender)
    EmbeddableContactFormFieldTemplate.create(dob)
  end
end
