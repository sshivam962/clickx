# frozen_string_literal: true

FactoryBot.define do
  factory :comment do |comment|
    user
    comment.comment   { Faker::Lorem.sentence }
    comment.user_name { Faker::Name.name }
    content
  end
end
