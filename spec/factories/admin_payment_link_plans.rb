FactoryBot.define do
  factory :admin_payment_link_plan do
    description_line_1 { "MyString" }
    description_line_2 { "MyString" }
    amount { 1.5 }
    billing_category { "MyString" }
    implementation_fee { 1.5 }
    pay_with_implementation_fee { false }
    stripe_plan_id { "MyString" }
    deleted_at { "2021-06-07 14:59:30" }
    payment_link { nil }
  end
end
