class Portfolio < ApplicationRecord
  acts_as_paranoid
  obfuscatable
  has_many :images, class_name: 'PortfolioImage', dependent: :destroy,
           inverse_of: :portfolio
  has_one :image, as: :imageable, inverse_of: :imageable
  has_one :thumbnail, as: :thumbnailable, inverse_of: :thumbnailable
  belongs_to :agency, optional: true

  accepts_nested_attributes_for :images,
                              reject_if: :all_blank,
                              allow_destroy: true
  accepts_nested_attributes_for :thumbnail,
                                reject_if: :all_blank,
                                allow_destroy: true

  scope :active, -> { where(draft: [nil, false]) }
  scope :common, -> { where(agency_id: 0) }

  CATEGORY_INFO = [
    {
      name: 'Landing Pages',
      key: 'landing_pages',
      icon: 'portfolio/landing_pages.png'
    },
    {
      name: 'Banner Ads',
      key: 'banner_ads',
      icon: 'portfolio/banner_ads.png'
    },
    {
      name: 'Digital PR',
      key: 'digital_pr',
      icon: 'portfolio/digital_pr.png'
    },
    {
      name: 'Brand Building',
      key: 'brand_building',
      icon: 'portfolio/brand_building.svg'
    },
    {
      name: 'Video',
      key: 'video',
      icon: 'portfolio/video.svg'
    }
  ]

  enum category: CATEGORY_INFO.pluck(:key)

  enum tier: %i[starter pro advanced]

  validates :thumbnail, presence: true
  validate :validate_assets

  def validate_assets
    if video?
      return if video_embed_code.present?

      errors.add(:base, 'Video should be present')
    else
      return if images.present?

      errors.add(:base, 'Image should be present')
    end
  end

  def self.category_collection
    CATEGORY_INFO.map { |ci| [ci[:name].upcase, ci[:key]] }
  end

  def thumbnail_url
    if thumbnail.present?
      thumbnail.file.url
    else
      images.first.file.url
    end
  end

  def has_access?(package_name)
    package_tier =
      if package_name.blank? || tier.blank?
        'free'
      else
        package_name.scan(/starter|pro|advanced/).last
      end

    Portfolio.tiers[package_tier] >= read_attribute_before_type_cast(:tier)
  end
end
