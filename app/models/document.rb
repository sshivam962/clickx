class Document < ApplicationRecord
  has_one :thumbnail, as: :thumbnailable, inverse_of: :thumbnailable
  has_one :document_attachment, dependent: :destroy
  belongs_to :agency, optional: true
  accepts_nested_attributes_for :thumbnail,
                                reject_if: :all_blank,
                                allow_destroy: true
  accepts_nested_attributes_for :document_attachment,
                                reject_if: :all_blank,
                                allow_destroy: true

  CATEGORY_INFO = {
    'miscellaneous' => 'Get Started',
    'questionnaires' => 'Questionnaires',
    'strategies' => 'Strategies',
    'proposals' => 'Sales'
  }

  PLAN_299 = %w[
    miscellaneous questionnaires
  ]

  PLAN_799 = PLAN_299 + %w[
    strategies proposals
  ]

  enum category: CATEGORY_INFO.keys

  enum tier: %i[free starter pro advanced]

  scope :agency_documents, -> { where(is_admin_type: false) }
  scope :admin_documents, -> { where(is_admin_type: true) }

  def self.category_collection
    CATEGORY_INFO.keys.map { |c| [CATEGORY_INFO[c], c] }
  end

  def has_access?(package_name)
    package_tier =
      if package_name.blank? || tier.blank?
        'free'
      else
        package_name.split('_').last
      end

    Document.tiers[package_tier] >= read_attribute_before_type_cast(:tier)
  end

end
