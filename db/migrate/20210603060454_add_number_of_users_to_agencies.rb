class AddNumberOfUsersToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :number_of_users, :integer
  end
end
