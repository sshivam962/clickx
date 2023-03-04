# frozen_string_literal: true

FactoryBot.define do
  factory :agency_admin_business_email_preference do
    user
    business
  end
end
