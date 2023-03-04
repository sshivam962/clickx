class NetworkMembership < ApplicationRecord
  belongs_to :network_profile
  validates :network_profile, uniqueness: true

  def progress_percent
    ([
      community_joined,
      publish_blog,
      fb_profile_add,
      social_links_add,
      post_about_network,
      personal_social_links_add,
      linkedin_add
    ].count(true) * 100)/7
  end
end
