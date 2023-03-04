class CaseStudy < ApplicationRecord
  acts_as_paranoid
  obfuscatable

  belongs_to :assignee, class_name: 'User', optional: true
  has_many :case_study_industries
  has_many :industries, through: :case_study_industries
  has_many :favorite_case_studies, dependent: :destroy

  has_many :old_images, as: :imageable, inverse_of: :imageable, class_name: 'Image'
  has_many :images, -> { order(position: :asc) },
           class_name: 'CaseStudyImage', dependent: :destroy,
           inverse_of: :case_study
  belongs_to :agency, optional: true
  belongs_to :network_profile, optional: true

  accepts_nested_attributes_for :images,
                                reject_if: :all_blank,
                                allow_destroy: true

  validates :title, presence: true
  validates :tier, presence: true
  validates :status, presence: true

  enum tier: %i[starter pro accelerate advanced]
  enum status: %i[draft published]

  SERVICES = [
    'Facebook Ads',
    'Facebook Ads Ecommerce',
    'Google & YouTube Ads',
    'Linkedin Ads',
    'Local SEO',
    'Advanced SEO'
  ]

  CATEGORIES = [
    {
      id: 1,
      key: 'fb',
      name: 'Meta Ads',
      bg: 'awesome-card--meta',
      services: ['Facebook Ads', 'Facebook Ads Ecommerce']
    },
    {
      id: 2,
      key: 'google',
      name: 'Google Ads',
      bg: 'awesome-card--google',
      services: ['Google & YouTube Ads']
    },
    {
      id: 3,
      key: 'seo',
      name: 'SEO',
      bg: 'awesome-card--seo',
      services: ['Local SEO', 'Advanced SEO']
    },
    {
      id: 4,
      key: 'linkedin',
      name: 'LinkedIn Ads',
      bg: 'awesome-card--linkedin',
      services: ['Linkedin Ads']
    }
  ]

  CATEGORIES.each do |category|
    query = category[:services].map{ |s| "'#{s}' = ANY(services)" }.join(' OR ')
    scope category[:key], -> { where(query) }
  end

  scope :priority_order, (lambda do
    order(
      <<~CODE
        in_their_words DESC NULLS LAST,
        stat1_text DESC NULLS LAST,
        created_at desc
      CODE
    )
  end)

  scope :with_service, (lambda do |service|
    if service.present?
      where(":name = ANY(services)", name: service)
    else
      all
    end
  end)

  def has_access?(package_name)
    return if package_name.blank? || tier.blank?

    package_tier = package_name.scan(Regexp.new(Agency::PLAN_KEYS.join('|'))).last
    CaseStudy.tiers[package_tier] >= read_attribute_before_type_cast(:tier)
  end

  def stat_missing?
    stat1_text.blank? ||
      stat1_value.blank? ||
      stat2_text.blank? ||
      stat2_value.blank? ||
      stat3_text.blank? ||
      stat3_value.blank?
  end
end
