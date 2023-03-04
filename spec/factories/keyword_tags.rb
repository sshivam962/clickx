# frozen_string_literal: true
FactoryBot.define do
  factory :keyword_tag do
    business
    name { Faker::Name.name }
    color { Faker::Color.hex_color }
  end
end
