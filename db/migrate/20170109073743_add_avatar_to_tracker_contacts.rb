class AddAvatarToTrackerContacts < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts, :avatar, :string
  end
end
