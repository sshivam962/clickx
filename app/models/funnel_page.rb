class FunnelPage < ApplicationRecord
  obfuscatable

  belongs_to :industry
  belongs_to :agency, optional: true
  belongs_to :funnel_page, optional: true
  validates :title, presence: true
  scope :published, -> { where.not(draft: true) }

  PLACEHOLDERS = {
    agency_name: 'agency'
  }

end
