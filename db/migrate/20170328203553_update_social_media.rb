class UpdateSocialMedia < ActiveRecord::Migration[4.2]
  def change
    SocialPost.unscoped.find_each do |record|
      record.published_posts.each do |post|
        if post[0].starts_with?('F-')
          SocialMedium.create(site: 'F',
                              page_id: post[0][2..-1],
                              post_id: post[1],
                              social_post: record)
        elsif post[0].starts_with?('L-')
          SocialMedium.create(site: 'L',
                              page_id: post[0][2..-1],
                              post_id: post[1],
                              social_post: record)
        elsif post[0].starts_with?('F')
          SocialMedium.create(site: 'F',
                              post_id: post[1],
                              social_post: record)
        elsif post[0].starts_with?('L')
          SocialMedium.create(site: 'L',
                              post_id: post[1],
                              social_post: record)
        elsif post[0].starts_with?('T')
          SocialMedium.create(site: 'T',
                              post_id: post[1],
                              social_post: record)
        end
      end
    end
  end
end
