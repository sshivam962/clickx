# frozen_string_literal: true
FactoryBot.define do
  factory :onboarding_procedure do
    business
    agency
    title { Faker::Company.name }
  end
end
