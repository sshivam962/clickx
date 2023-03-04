# frozen_string_literal: true
class OnboardingTask < ApplicationRecord
  validates :title, :description, :task, presence: true
  belongs_to :onboarding_procedure
end
