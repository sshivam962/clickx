class AddContentToTrackerContactForm < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contact_forms, :content, :text
  end
end
