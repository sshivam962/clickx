# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email         { Faker::Internet.free_email }
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    password      { Faker::Internet.password(8) }
    invitation_accepted_at { Time.current }
    role          { User::CompanyUser }
  end

  factory :company_admin, class: User do |_usr|
    email         { Faker::Internet.free_email }
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    password      { Faker::Internet.password(8) }
    role          { User::CompanyAdmin }
    invitation_accepted_at { Time.current }
    association :ownable, factory: :business
  end

  factory :agency_admin, class: User do |_usr|
    email         { Faker::Internet.free_email }
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    password      { Faker::Internet.password(8) }
    role          { User::AgencyAdmin }
    invitation_accepted_at { Time.current }
    association :ownable, factory: :agency
  end

  factory :super_admin, class: User do |_usr|
    email         { Faker::Internet.free_email('admin') }
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    password      { Faker::Internet.password(8) }
    role          { User::Admin }
    invitation_accepted_at { Time.current }
  end
end
