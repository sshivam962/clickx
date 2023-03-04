class RemaneBusinessIdToOwnableIdToUser < ActiveRecord::Migration[4.2]
  def up
	  rename_column :users, :business_id, :ownable_id
	  add_column :users, :ownable_type, :string
	  User.reset_column_information
	  User.update_all(:ownable_type => "Business")
	end

	def down
	  rename_column :users, :ownable_id, :business_id
	  remove_column :users, :ownable_type
	end
end
