class PaymentLink < ApplicationRecord
  acts_as_paranoid

  belongs_to :agency
  belongs_to :resource, polymorphic: true, touch: true
  belongs_to :business_user, class_name: 'User', optional: true
  has_one :plan, class_name: 'PaymentLinkPlan', dependent: :destroy
  delegate :stripe_credential, to: :agency

  enum status: %i[active paid]
  accepts_nested_attributes_for :plan

  scope :not_paid, -> { where.not(status: :paid) }
  scope :enabled, -> { active.where(disabled: false) }

  def enabled?
    active? && !disabled?
  end

  def display_name
    return resource.name if resource_type.eql?('Lead')
    return business_user.name if business_user

    user_name
  end

  def display_email
    return resource.email if resource_type.eql?('Lead')
    return business_user.email if business_user

    user_email
  end

  def display_company
    return resource.company if resource_type.eql?('Lead')

    resource&.name
  end

  def display_name_with_email
    "#{display_name}<#{display_email}>"
  end

  def user_info
    { name: display_name, email: display_email, company: display_company }
  end
end
