# frozen_string_literal: true

FactoryBot.define do
  factory :business do
    agency
    name { Faker::Company.name }
    domain { Faker::Internet.url }

    trait :with_users do
      transient do
        users_count { 5 }
      end

      after(:create) do |business, evaluator|
        create_list(:user, evaluator.users_count, ownable: business)
      end
    end
    contact_mailing_list { ['test@test.co', 'hello@test.com'] }
  end
end
