class AddFullAccessToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :full_access, :boolean, default: false
  end
end
