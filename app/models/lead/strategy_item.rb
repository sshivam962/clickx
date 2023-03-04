class Lead::StrategyItem < ApplicationRecord
  enum category: %i[
    facebook_leadgen linkedin_leadgen facebook_ecommerce google_leadgen google_ecommerce seo
  ]

  validates :category, presence: true

  CATEGORIES = {
    facebook_leadgen: 'Facebook Lead Gen',
    facebook_ecommerce: 'Facebook Ecommerce',
    google_leadgen: 'Google Lead Gen',
    google_ecommerce: 'Google Ecommerce',
    linkedin_leadgen: 'Linkedin Lead Gen',
    seo: 'SEO'
  }

  PLACEHOLDERS = {
    company_name: 'company'
  }

  scope :google_facebook_leadgen, -> {
    where(category: %i[facebook_leadgen google_leadgen])
  }

  scope :google_facebook_ecommerce, -> {
    where(category: %i[facebook_ecommerce google_ecommerce])
  }

  scope :favorite, -> { where(favorite: true) }
end
