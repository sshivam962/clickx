class AddFieldsToTrackerContactForm < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contact_forms, :header_text, :string
    add_column :tracker_contact_forms, :position, :string
  end
end
