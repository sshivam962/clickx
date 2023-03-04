class AddIndexToFbPosts < ActiveRecord::Migration[4.2]
  def change
    add_index :fb_posts, :user_id
  end
end
