# frozen_string_literal: true

FactoryBot.define do
  factory :backlink_datum do
    business_id { 1 }
    summary { '' }
    backlinks { '' }
    anchor_text { '' }
    topics { '' }
    pages { '' }
    ref_domains { '' }
  end
end
