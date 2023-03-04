class CopyUrlDataToUrlPreview < ActiveRecord::Migration[4.2]
  def change
    SocialPost.find_each(batch_size: 100) do |post|
      post.url_preview = {
        description: post.url_data,
        title:       post.url_title,
        images:      [{ src: post.url_image }],
        short_url:   post.url_short
      }
      post.save
    end
  end
end
