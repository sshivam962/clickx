# frozen_string_literal: true

class ContentOrderDefault < ApplicationRecord
  belongs_to :business
  validates :business_id, uniqueness: true
end
