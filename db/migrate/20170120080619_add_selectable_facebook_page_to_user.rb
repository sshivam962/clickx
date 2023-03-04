class AddSelectableFacebookPageToUser < ActiveRecord::Migration[4.2]
  def change
  	add_column :users, :selected_fb_pages, :string, array: true, default: []
  end
end
