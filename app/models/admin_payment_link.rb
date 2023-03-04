class AdminPaymentLink < ApplicationRecord
  acts_as_paranoid

  has_one :admin_plan, class_name: 'AdminPaymentLinkPlan', dependent: :destroy
  belongs_to :user
  accepts_nested_attributes_for :admin_plan
  enum status: %i[active paid]

  def enabled?
    active? && !disabled?
  end

  def user_info
    { name: name, email: email }
  end
end
