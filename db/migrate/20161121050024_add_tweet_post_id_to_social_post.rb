class AddTweetPostIdToSocialPost < ActiveRecord::Migration[4.2]
  def change
  	add_column :social_posts, :tweet_post_id, :string
  end
end
