class AddLastLoggedInToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :last_logged_in, :datetime
    add_column :agencies, :last_logged_in_user_id, :integer
  end
end
