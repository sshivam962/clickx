class AddMessageFieldInTrackerContcats < ActiveRecord::Migration[4.2]
  def change
    add_column :tracker_contacts, :message, :text
  end
end
