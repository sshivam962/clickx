
# frozen_string_literal: true

FactoryBot.define do
  factory :social_link do |lnk|
    lnk.link_type { Faker::Internet.domain_name }
    lnk.link      { Faker::Internet.url }
  end
end
