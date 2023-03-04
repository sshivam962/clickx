# frozen_string_literal: true

class BusinessOnboardingProcedure < ApplicationRecord
  belongs_to :business
  belongs_to :onboarding_procedure
  validates :onboarding_procedure_id, uniqueness: { scope: :business_id }
end
