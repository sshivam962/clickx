# frozen_string_literal: true

FactoryBot.define do
  factory :task do |task|
    task.sub_tasks  { Faker::Lorem.words }
    task.state      { '' }
    task.task_type  { Faker::Lorem.characters(10) }
    business
  end
end
