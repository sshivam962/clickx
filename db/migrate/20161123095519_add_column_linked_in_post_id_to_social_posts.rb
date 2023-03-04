class AddColumnLinkedInPostIdToSocialPosts < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :linked_in_post_id, :string
  end
end
