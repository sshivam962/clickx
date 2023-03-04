# frozen_string_literal: true

FactoryBot.define do
  factory :agency do |agency|
    agency.name           { Faker::Company.name }
    agency.phone          { Faker::PhoneNumber.phone_number }
    agency.support_email  { Faker::Internet.email('clickx') }
    agency.logo           { Faker::Company.logo }
    agency.address        do
      [Faker::Address.city, Faker::Address.street_name,
       Faker::Address.street_address, Faker::Address.state,
       Faker::Address.zip, Faker::Address.country].join(', ')
    end
  end
end
