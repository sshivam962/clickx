# frozen_string_literal: true
FactoryBot.define do
  factory :token do
    business
    code_type { 'google_adwords' }
    access_token { Faker::Code.npi }
  end
end
