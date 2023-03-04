class AddCustomFieldsToTrackerContacts < ActiveRecord::Migration[5.1]
  def change
    add_column :tracker_contacts, :custom_fields, :jsonb, default: {}
  end
end
