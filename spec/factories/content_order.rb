# frozen_string_literal: true

FactoryBot.define do
  factory :content_order do
    business
    user
    form_data do
      { title: Faker::Lorem.sentence,
        writer: Faker::Name.name,
        maxwords: 100 }
    end
    order_price { 20.18 }
    payment_information { Faker::Lorem.sentence }
  end
end
