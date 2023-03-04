# frozen_string_literal: true
class DomainRanking < ApplicationRecord
  scope :on, ->(keyword_name, domain) { where(keyword_name: keyword_name, domain: domain) }

  def self.first_or_dup_on(keyword_name:, domain:)
    first_element = on(keyword_name, domain).first
    return first_element if first_element
    rank = begin
             where('keyword_name = ? and domain = ?', keyword_name, domain)
               .first_or_initialize
           rescue StandardError
             order(created_at: :desc).first_or_initialize
           end
    rank.keyword_name = keyword_name
    rank.domain = domain
    rank
  end
end
