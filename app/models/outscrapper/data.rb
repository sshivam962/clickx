# frozen_string_literal: true
class Outscrapper::Data < ApplicationRecord
  acts_as_paranoid
  belongs_to :agency
  validates :outscrapper_request_id, presence: true
end
