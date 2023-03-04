FactoryBot.define do
  factory :admin_payment_link_subscription do
    account_id { "MyString" }
    amount { 1 }
    currency { "MyString" }
    customer { "MyString" }
    interval { "MyString" }
    status { "MyString" }
    billing_category { 1 }
    metadata { "" }
    billing_type { 1 }
    quantity { 1 }
    canceled_at { "2021-06-08 02:59:32" }
    cancel_at { "2021-06-08 02:59:32" }
    admin_payment_link_plan { nil }
  end
end
