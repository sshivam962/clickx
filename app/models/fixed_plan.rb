class FixedPlan < ApplicationRecord
  belongs_to :agency
  belongs_to :plan

  validates :package_id, uniqueness: { scope: :agency_id }

  before_validation :set_package, on: :create

  private

  def set_package
    self.package_id = plan.package_id
  end
end
