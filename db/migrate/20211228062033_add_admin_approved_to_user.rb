class AddAdminApprovedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin_approved, :boolean, deafult: false
  end
end
