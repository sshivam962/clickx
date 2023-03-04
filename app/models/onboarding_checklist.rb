class OnboardingChecklist < ApplicationRecord

  belongs_to :onboarding_section

  validates :title, uniqueness: true, presence: true

end
