class AddEmailalertToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :email_alert, :boolean, default: false
  end
end
