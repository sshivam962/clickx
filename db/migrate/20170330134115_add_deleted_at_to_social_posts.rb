class AddDeletedAtToSocialPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :social_posts, :deleted_at, :datetime
    add_index :social_posts, :deleted_at
  end
end
