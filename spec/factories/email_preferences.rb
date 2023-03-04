# frozen_string_literal: true

FactoryBot.define do
  factory :email_preference do
    key { EmailPreference::KEYS.sample }
    feature { EmailPreference::FEATURES.keys.sample } # rubocop:disable Capybara/FeatureMethods
    # ownable nil
    association :ownable, factory: :user
    enabled { false }
    recurring { 1 }
  end

  factory :user_email_preference do
    key { EmailPreference::KEYS.keys.sample }
    feature { EmailPreference::FEATURES.sample } # rubocop:disable Capybara/FeatureMethods
    association :ownable, factory: :user
    enabled { false }
    recurring { 1 }
  end

  factory :business_email_preference do
    key { EmailPreference::KEYS.keys.sample }
    feature { EmailPreference::FEATURES.sample } # rubocop:disable Capybara/FeatureMethods
    association :ownable, factory: :business
    enabled { false }
    recurring { 1 }
  end
end
