# frozen_string_literal: true
# Table name: network_memberships
#
#  id                         :bigint           not null, primary key
#  community_joined           :string
#  publish_blog               :string
#  fb_profile_add             :string
#  social_links_add           :string
#  post_about_network         :string
#  personal_social_links_add  :string
#  linkedin_add               :string
#  completed                  :string
#  completed_at               :datetime
#  user_id                    :bigint
#
# Indexes
#
#  index_network_memberships_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
FactoryBot.define do
  factory :network_membership do
    community_joined { "true" }
    publish_blog { "true" }
    fb_profile_add { "true" }
    social_links_add { "true" }
    post_about_network { "true" }
    personal_social_links_add { "true" }
    linkedin_add { "true" }
    completed { "true" }
  end
end
