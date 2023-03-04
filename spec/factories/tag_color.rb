# frozen_string_literal: true

FactoryBot.define do
  factory :tag_color do
    tag { 'sample' }
    color { '#F60' }
    business
  end
end
