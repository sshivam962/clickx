class AddCompanyFieldToTrackerContacts < ActiveRecord::Migration[4.2]
  def change
    add_reference :tracker_contacts, :tracker_company, index: true, foreign_key: true
  end
end
