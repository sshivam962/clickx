class RenameMediaCompletedMediaColumnFromSocialPost < ActiveRecord::Migration[4.2]
  def change
    remove_column :social_posts, :media, :integer, array: true, default: []
    remove_column :social_posts, :completed_media, :integer, array: true, default: []

    add_column :social_posts, :media, :string, array: true, default: []
    add_column :social_posts, :completed_media, :string, array: true, default: []
  end
end
