# frozen_string_literal: true

FactoryBot.define do
  factory :location do |loc|
    business
    loc.name       { Faker::Company.name }
    loc.address    { Faker::Address.street_address }
    loc.city       { Faker::Address.city }
    loc.state      { Faker::Address.state }
    loc.country    { Faker::Address.country }
    loc.zip        { Faker::Address.zip }
    loc.phone      { Faker::PhoneNumber.phone_number }
    loc.website    { Faker::Internet.url }

    after(:create) do |_user, _evaluator|
      create_list(:social_link, 3)
    end
  end
end
