# frozen_string_literal: true

FactoryBot.define do
  factory :business_hour do
    days { 'MyString' }
    status { 'MyString' }
    from { '2016-01-28 19:43:10' }
    to { '2016-01-28 19:43:10' }
    location { nil }
  end
end
