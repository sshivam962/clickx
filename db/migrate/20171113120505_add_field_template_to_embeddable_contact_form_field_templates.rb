class AddFieldTemplateToEmbeddableContactFormFieldTemplates < ActiveRecord::Migration[5.1]

  def up
    templates = [
      {
        name: 'First Name',
        name_slug: 'first_name',
        field_type: 'text',
        label: 'First Name',
        placeholder: nil,
      },
      {
        name: 'Last Name',
        name_slug: 'last_name',
        field_type: 'text',
        label: 'Last Name',
        placeholder: nil,
      },
      {
        name: 'Email',
        name_slug: 'email',
        field_type: 'email',
        label: 'Email',
        placeholder: nil,
      },
      {
        name: 'Phone Number',
        name_slug: 'phone_number',
        field_type: 'tel',
        label: 'Phone Number',
        placeholder: nil,
      },
      {
        name: 'Website URL',
        name_slug: 'website',
        field_type: 'url',
        label: 'Website URL',
        placeholder: nil,
      },
      {
        name: 'DOB',
        name_slug: 'date_of_birth',
        field_type: 'date',
        label: 'DOB',
        placeholder: nil,
      },
      {
        name: 'Time',
        name_slug: 'time',
        field_type: 'time',
        label: 'Time',
        placeholder: nil,
      },
      {
        name: 'Message',
        name_slug: 'message',
        field_type: 'textarea',
        label: 'Message',
        placeholder: nil,
      },
      {
        name: 'Gender',
        name_slug: 'gender',
        field_type: 'radio',
        label: 'Gender',
        placeholder: nil,
        answer_options: ['Male', 'Female', 'Other']
      },
      {
        name: 'Languages',
        name_slug: 'languages',
        field_type: 'select',
        label: 'Languages',
        placeholder: nil,
        answer_options: ['English', 'Spanish', 'French', 'Other']
      }
    ]
    templates.each do |template|
      EmbeddableContactFormFieldTemplate.create(template)
    end
  end

  def down
    ActiveRecord::Base.connection.execute("TRUNCATE embeddable_contact_form_field_templates")  
  end
end
