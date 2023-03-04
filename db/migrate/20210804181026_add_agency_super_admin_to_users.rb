class AddAgencySuperAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :agency_super_admin, :boolean, :default => false
  end
end