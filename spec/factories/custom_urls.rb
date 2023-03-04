# frozen_string_literal: true
FactoryBot.define do
  factory :custom_url do |_custom_url|
    website_url      { FFaker::Internet.http_url }
    campaign_source  { 'website' }
    campaign_medium  { 'facebook' }
    campaign_name    { 'email' }
    campaign_term    { 'promotion' }
    campaign_content { Faker::Lorem.sentence }
    complete_url     { FFaker::Internet.http_url }
    business
  end
end
