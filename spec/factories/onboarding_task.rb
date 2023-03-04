# frozen_string_literal: true
FactoryBot.define do
  factory :onboarding_task do
    onboarding_procedure
    title { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    task { Faker::Company.name }
  end
end
