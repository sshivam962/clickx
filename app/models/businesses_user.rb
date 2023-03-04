# frozen_string_literal: true

class BusinessesUser < ApplicationRecord
  belongs_to :business
  belongs_to :user
  validates :business_id, uniqueness: { scope: :user_id }
end
