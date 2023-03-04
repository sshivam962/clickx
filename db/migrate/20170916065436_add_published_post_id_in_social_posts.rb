class AddPublishedPostIdInSocialPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :social_posts, :published_post_id, :string
  end
end
