class AddonPlan < ApplicationRecord
  belongs_to :plan
  belongs_to :resource, polymorphic: true
  validates :resource_type, inclusion: { in: %w[Package Plan] }

  def package
    return unless resource_type.eql?('Package')

    resource
  end
end
