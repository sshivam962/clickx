# frozen_string_literal: true

FactoryBot.define do
  factory :intelligence_cache do
    business
    best_performing_ads { {} }
    contacts_overview { {} }
    contacts_per_day { {} }
    new_contacts_by_source { {} }
    top_10_keywords { {} }
  end
end
