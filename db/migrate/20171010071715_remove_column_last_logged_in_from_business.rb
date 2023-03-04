class RemoveColumnLastLoggedInFromBusiness < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :last_logged_in
  end
end
