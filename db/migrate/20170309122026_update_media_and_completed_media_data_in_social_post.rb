class UpdateMediaAndCompletedMediaDataInSocialPost < ActiveRecord::Migration[4.2]
  def change
    SocialPost.with_deleted.find_each do |post|
      post.media = post.temp_media
      post.completed_media = post.temp_completed_media
      post.save
    end
  end
end
