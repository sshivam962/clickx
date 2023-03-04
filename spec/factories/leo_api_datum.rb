# frozen_string_literal: true

FactoryBot.define do
  factory :leo_api_datum do
    business
    project_id { SecureRandom.uuid }
  end
end
