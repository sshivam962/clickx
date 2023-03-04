# frozen_string_literal: true

class KeywordBase < ApplicationRecord
  self.table_name = 'keywords'

  belongs_to :business, -> { with_deleted }

  validates :name, presence: true,
                   uniqueness: { scope: %i[deleted_at type locale city business_id] }

  before_validation do
    normalize_name
    city&.downcase!
  end

  def normalize_name
    name.tr!('+', '')
    name.strip!
    name.downcase!
    name.squish!
    name.encode("UTF-8")
  end
end
