# frozen_string_literal: true

class StateTracker < ApplicationRecord
  ContentStates = %w[start draft review review_submitted final_proof approved].freeze

  belongs_to :content
  belongs_to :user
  validates :transition_date, presence: true

  validates :from_state, :to_state, inclusion: {
    in: ContentStates,
    message: 'not a valid state'
  }
end
