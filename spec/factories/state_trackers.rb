# frozen_string_literal: true

FactoryBot.define do
  factory :state_tracker do
    from_state { 'start' }
    to_state { 'draft' }
    transition_date { Faker::Time.between(DateTime.now - 1, DateTime.now) }
    user_name { Faker::Name.name }
    content
    user
  end
end
