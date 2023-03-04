# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    content { 'test' }
    action { 'edited_content' }
    user
    actor { nil }
    target { nil }
    read_at { nil }
  end
end
