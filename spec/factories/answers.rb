# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    answer { 'MyString' }
    oneliner { 'MyString' }
    multiline { 'MyString' }
    boolean_ans { false }
  end
end
