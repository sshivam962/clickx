class AddFbColumnsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :fb_page,  :string 
    add_column :businesses, :fb_likes, :integer
  end
end
