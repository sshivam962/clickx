class AddFullContactDataToTrackerContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts,:full_contact_data,:jsonb
    add_column :tracker_contacts,:hcard,:jsonb
    add_column :tracker_contacts,:organizations,:jsonb
    add_column :tracker_contacts,:demographics,:jsonb
    add_column :tracker_contacts,:social_profiles,:jsonb
  end
end
