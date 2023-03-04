class AddClearBitFieldsToTrackerContact < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts, :clearbit_response, :jsonb
    add_column :tracker_contacts, :twitter, :string
    add_column :tracker_contacts, :linkedin, :string
    add_column :tracker_contacts, :website, :string
    add_column :tracker_contacts, :aboutme, :string
  end
end
