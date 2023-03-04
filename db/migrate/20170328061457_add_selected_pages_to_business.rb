class AddSelectedPagesToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :selected_fb_pages, :string, array: true, default: []
    add_column :businesses, :selected_linkedin_pages, :string, array: true, default: []
  end
end
