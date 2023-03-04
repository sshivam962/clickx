class Internal::Package < ApplicationRecord
  has_many :plans,
           class_name: 'Internal::Plan',
           foreign_key: :clickx_package_id,
           dependent: :destroy

  validates :key, uniqueness: true

  scope :business_signup, -> { find_by(key: :business_signup) }

  def questionnaire_categories
    []
  end
end
