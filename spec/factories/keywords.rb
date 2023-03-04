# frozen_string_literal: true
FactoryBot.define do
  factory :keyword do
    business
    name { 'Sample Keyword' }
    city { 'new york, ny, united states' }
    kdi { 1234.5678 }

    trait :with_keyword_tags do
      after(:create) do |keyword, _|
        keyword.keyword_tags << create_list(:keyword_tag, 3, business: keyword.business)
      end
    end
  end
end
