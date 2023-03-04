class AddLastLoggedInUserIdToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :last_logged_in_user_id, :integer
  end
end
