# frozen_string_literal: true

FactoryBot.define do
  factory :competition do
    name { Faker::Internet.url }
    logo { FFaker::Internet.http_url }
    business
    summary { { item: 'google.com' } }
    backlinks { [] }
    keywords_organic { [] }
    keywords_adwords { [] }
  end
end
