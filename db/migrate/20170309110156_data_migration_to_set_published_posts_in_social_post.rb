class DataMigrationToSetPublishedPostsInSocialPost < ActiveRecord::Migration[4.2]
  def change
    SocialPost.with_deleted.find_each do |post|
      new_media = []
      if post.media.present?
        post.media.each do |med|
          case med
          when 0
            new_media << 'F'
          when 1
            if post.fb_page_ids.present?
              post.fb_page_ids.each do |page_id|
                new_media << "F-#{page_id}"
              end
            end
          when 2
            new_media << 'T'
          when 3
            new_media << 'L'
          end
        end
      end
      post.temp_media = new_media
      post.save

      new_completed_media = []
      if post.completed_media.present?
        post.completed_media.each do |med|
          case med
          when 0
            new_completed_media << 'F'
          when 1
            if post.completed_fb_page_ids.present?
              post.completed_fb_page_ids.each do |page_id|
                new_completed_media << "F-#{page_id}"
              end
            end
          when 2
            new_completed_media << 'T'
          when 3
            new_completed_media << 'L'
          end
        end
      end
      post.temp_completed_media = new_completed_media
      post.save

      new_publish_post = {}
      new_publish_post[:T] = post.tweet_post_id if post.tweet_post_id
      new_publish_post[:F] = post.facebook_post_id if post.facebook_post_id
      new_publish_post[:L] = post.linked_in_post_id if post.linked_in_post_id
      if post.fb_page_ids.present?
        post.fb_page_ids.each do |page_id|
          if post.facebook_page_post_id[page_id.to_s]
            new_publish_post.merge!("F-#{page_id}": post.facebook_page_post_id[page_id.to_s])
          end
        end
      end
      post.published_posts = new_publish_post
      post.save
    end
  end
end
