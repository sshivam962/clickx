class AddUrlPreviewToSocialPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :social_posts, :url_preview, :jsonb
  end
end
