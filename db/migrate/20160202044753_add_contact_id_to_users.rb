class AddContactIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :autopilot_contact_id, :string
  end
end
