class ChangeTrackerContactAssociation < ActiveRecord::Migration[4.2]
  def change
    add_reference :tracker_visitors, :tracker_contact, index: true
    add_foreign_key :tracker_visitors, :tracker_contacts
  end
end
