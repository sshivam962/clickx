class AddNameToTrackerContactForm < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contact_forms, :name, :string
  end
end
