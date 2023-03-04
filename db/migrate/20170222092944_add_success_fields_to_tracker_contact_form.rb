class AddSuccessFieldsToTrackerContactForm < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contact_forms, :success_message_enabled, :boolean
    add_column :tracker_contact_forms, :success_message_type, :string
    add_column :tracker_contact_forms, :success_url_enabled, :boolean
    add_column :tracker_contact_forms, :success_message, :string
    add_column :tracker_contact_forms, :success_url, :string
  end
end
