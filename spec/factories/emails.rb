FactoryBot.define do
  factory :email do
    mailer_function_name { "MyString" }
    to_addresses { "MyString" }
    cc_addresses { "MyString" }
    bcc_addresses { "MyString" }
  end
end
