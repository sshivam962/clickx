class AgencyNiche < ApplicationRecord
  belongs_to :agency
  belongs_to :industry

  validates :agency_id, :industry_id, presence: true
  validates :agency_id, uniqueness: { scope: :industry_id }
end
