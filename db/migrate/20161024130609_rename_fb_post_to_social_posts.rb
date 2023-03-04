class RenameFbPostToSocialPosts < ActiveRecord::Migration[4.2]
  def change
  	rename_table :fb_posts, :social_posts
  end
end
