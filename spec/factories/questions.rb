# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    question { 'MyString' }
    description { 'MyString' }
    group_type { 'MyString' }
    exp_ans_type { 'MyString' }
    min_ans_req { 1 }
    is_published { false }
    version { 1 }
    mandatory { false }
  end
end
