class AddColumnPublishedPostToSocialPost < ActiveRecord::Migration[4.2]
  def change
    add_column :social_posts, :published_posts, :jsonb, default: {}
    add_column :social_posts, :temp_media, :string, array: true, default: []
    add_column :social_posts, :temp_completed_media, :string, array: true, default: []
  end
end
