class ChangeFbPagePostIdToHash < ActiveRecord::Migration[4.2]
  def change
    remove_column :social_posts, :facebook_page_post_id
    add_column :social_posts, :facebook_page_post_id, :json, default: {}
  end
end
