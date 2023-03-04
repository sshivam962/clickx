class UpdateSocialAccountWithMediaData < ActiveRecord::Migration[4.2]
  def change
    SocialPost.where("array_length(media,1) = 1").find_each do |post|
      post.social_account = post.media.first
      post.completed = post.completed_media.present?
      post.save
    end

    SocialPost.where("array_length(media,1) > 1").find_each do |post|
      post.completed = post.completed_media.present?
      post.social_account = post.media.first
      post.save
      post.media[1..-1].each do |media|
        new_post = post.dup
        new_post.social_account = media
        new_post.save
      end
    end
  end
end
