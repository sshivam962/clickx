FactoryBot.define do
  factory :admin_payment_link do
    name { "MyString" }
    email { "MyString" }
    status { 1 }
    disabled { false }
    stripe_customer_id { "MyString" }
    deleted_at { "2021-06-07 09:57:26" }
  end
end
