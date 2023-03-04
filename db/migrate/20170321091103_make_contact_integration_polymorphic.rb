class MakeContactIntegrationPolymorphic < ActiveRecord::Migration[4.2]
  def up
    rename_column :tracker_contact_form_integrations, :business_id, :ownable_id
    add_column :tracker_contact_form_integrations, :ownable_type, :string
    TrackerContactFormIntegration.reset_column_information
    TrackerContactFormIntegration.update_all(ownable_type: 'Business')
  end

  def down
    rename_column :tracker_contact_form_integrations, :ownable_id, :business_id
    remove_column :tracker_contact_form_integrations, :ownable_type
  end
end
