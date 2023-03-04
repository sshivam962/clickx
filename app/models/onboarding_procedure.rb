# frozen_string_literal: true
class OnboardingProcedure < ApplicationRecord
  validates :title, presence: true#, uniqueness: { scope: :package_subscription }

  validates :onboarding_tasks,
            length: {
              minimum: 1,
              too_short: '- Please provide atleast one task'
            }

  amoeba do
    enable
  end

  belongs_to :package_subscription, optional: true

  has_many :onboarding_tasks, -> { order(position: :asc) },
           dependent: :destroy,
           inverse_of: :onboarding_procedure

  accepts_nested_attributes_for :onboarding_tasks,
                                reject_if: :all_blank,
                                allow_destroy: true

  scope :templates, -> { where(package_subscription_id: nil) }
  scope :assigned, -> { where.not(package_subscription_id: nil) }

  def tasks
    onboarding_tasks.order(:position)
  end
end
