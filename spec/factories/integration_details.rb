# frozen_string_literal: true
FactoryBot.define do
  factory :integration_detail do
    business
    details { { data: "string" } }
  end
end
