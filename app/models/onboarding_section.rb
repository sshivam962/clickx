class OnboardingSection < ApplicationRecord

  has_many :onboarding_checklist, dependent: :destroy, class_name: 'OnboardingChecklist'

  validates :title, uniqueness: true, presence: true

end
