class PopulatePublishedPostIdInSocialPosts < ActiveRecord::Migration[4.2]
  def up
    SocialMedium.find_each do |medium|
      medium.social_post.update_attributes(published_post_id: medium.post_id) if medium.social_post
    end
    #TODO destroy social medium table and model
  end
end
