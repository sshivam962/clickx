# frozen_string_literal: true

class Questionnaire < ApplicationRecord
  has_many :answers, dependent: :delete_all
  belongs_to :business
end
