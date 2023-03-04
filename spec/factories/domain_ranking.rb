# frozen_string_literal: true

FactoryBot.define do
  factory :domain_ranking do
    keyword_name { 'testing' }
    domain { 'google.com' }
    rank { 34 }
  end
end
