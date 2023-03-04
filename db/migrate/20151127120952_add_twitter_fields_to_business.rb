class AddTwitterFieldsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :twitter_handle,  :string 
    add_column :businesses, :twitter_followers_count, :integer
  end
end
