class RemoveObsoleteColumnsFromSocialPosts < ActiveRecord::Migration[4.2]
  def change
    remove_column :social_posts, :media
    remove_column :social_posts, :completed_media
  end
end
