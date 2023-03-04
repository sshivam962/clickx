class AddColumnSelectedLinkedinPageToUser < ActiveRecord::Migration[4.2]
	def up
 		add_column :users, :selected_linkedin_pages, :string, array: true, default: []
	end

	def down
		remove_column :users, :selected_linkedin_pages
	end
end
