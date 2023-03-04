# frozen_string_literal: true

class Task < ApplicationRecord
  States = %w[future current completed internal].freeze
  belongs_to :business

  before_validation(on: :create) do
    self.state = States[0]
  end

  validates :state, :task_type, presence: true

  validates :state, inclusion: {
    in: States,
    message: 'not a valid state'
  }

  default_scope { order('updated_at DESC') }
end
