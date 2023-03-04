# frozen_string_literal: true

FactoryBot.define do
  factory :webpush_subscription do
    endpoint { 'MyString' }
    p256dh { 'MyString' }
    auth { 'MyString' }
    user_visible_only { false }
    user
  end
end
