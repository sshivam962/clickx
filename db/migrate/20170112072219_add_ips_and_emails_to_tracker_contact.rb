class AddIpsAndEmailsToTrackerContact < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts, :ips, :inet, array: true, default: []
    add_column :tracker_contacts, :alternate_emails, :string, array: true, default: []
    add_index :tracker_contacts, :ips, using: 'gin'
    add_index :tracker_contacts, :alternate_emails, using: 'gin'
  end
end
