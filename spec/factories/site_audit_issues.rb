# frozen_string_literal: true
FactoryBot.define do
  factory :site_audit_issue do
    leo_api_datum
    url { Faker::Internet.url }
    page_id { SecureRandom.uuid }
  end
end
