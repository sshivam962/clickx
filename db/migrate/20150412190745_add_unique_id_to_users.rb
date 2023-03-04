class AddUniqueIdToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :unique_id, :string
  end
end
