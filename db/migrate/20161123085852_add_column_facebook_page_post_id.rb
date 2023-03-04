class AddColumnFacebookPagePostId < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :facebook_page_post_id, :string
  end
end
