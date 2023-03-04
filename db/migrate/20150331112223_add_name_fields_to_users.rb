class AddNameFieldsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :first_name, :string, null: false, default: ""
    add_column :users, :last_name, :string, null: false, default: ""
    add_column :users, :username, :string, null: false, default: ""
    add_column :users, :address, :text
    add_column :users, :phone, :string
  end
end
