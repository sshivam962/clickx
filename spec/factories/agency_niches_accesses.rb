FactoryBot.define do
  factory :agency_niches_access do
    agency { nil }
    access { false }
    industries_ids { "MyString" }
    access_type { "MyString" }
  end
end
