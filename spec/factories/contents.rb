# frozen_string_literal: true

FactoryBot.define do
  factory :content do |content|
    content.title  { Faker::Name.title }
    content.link   { Faker::Internet.url }
    content.state  { '' }
    content.content { '<table><tbody><tr><td>1. content </td></tr><tr><td>2.content </td></tr></tbody></table><p>1.content title </p><p style="margin-left: 20px;"></p><p>2.content title</p>' }
    content.meta_title { Faker::Name.title }
    content.meta_description { Faker::Lorem.paragraph }
    business

    factory :content_with_comments do
      after(:create) do |c, _evaluator|
        create_list(:comment, 3, content: c)
      end
    end
  end
end
