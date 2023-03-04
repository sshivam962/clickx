class DropSocialPosts < ActiveRecord::Migration[4.2]
  def change
  	drop_table :social_posts if ActiveRecord::Base.connection.table_exists? 'social_posts'
  end
end
