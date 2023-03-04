class AddColumnLastLoggedInToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :last_logged_in, :datetime
  end
end
