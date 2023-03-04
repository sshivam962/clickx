class RemoveUnwantedColumnFromSocialPost < ActiveRecord::Migration[4.2]
  def change
    remove_column :social_posts, :temp_media, :string, array: true, default: []
    remove_column :social_posts, :temp_completed_media, :string, array: true, default: []

    remove_column :social_posts, :fb_page_ids, :string, array: true, default: []
    remove_column :social_posts, :completed_fb_page_ids, :string, array: true, default: []
    remove_column :social_posts, :tweet_post_id, :string
    remove_column :social_posts, :facebook_post_id, :string
    remove_column :social_posts, :linked_in_post_id, :string
    remove_column :social_posts, :facebook_page_post_id, :json, default: {}
    remove_column :social_posts, :linkedin_page_ids, :string, array: true, default: []
    remove_column :social_posts, :completed_linkedin_page_ids, :string, array: true, default: []
    remove_column :social_posts, :linkedin_page_post_ids, :json, default: {}
  end
end
