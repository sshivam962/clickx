# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :questions, -> { order(position: :asc) }, dependent: :destroy
  validates :name, uniqueness: true, presence: true
end
