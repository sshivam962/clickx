class AgencyNichesAccess < ApplicationRecord
  belongs_to :agency

  validates :industries_ids, presence: true, if: :full_access_nil?

  def full_access_nil?
    full_access == false
  end
end
