# frozen_string_literal: true
class CustomPackage < ApplicationRecord
  belongs_to :agency, -> { with_deleted }
  belongs_to :business, -> { with_deleted }, optional: true

  has_one :package_subscription, dependent: :destroy

  enum status: %i[active paid]
  enum billing_category: %i[subscription charge]

  validates :package_name, uniqueness: { case_sensitive: false }

  before_create :set_package_name
  before_create :create_stripe_plan

  def plan
    Plan.new(
      name: name,
      product_name: product_name,
      amount: amount,
      stripe_plan: stripe_plan,
      package_name: package_name,
      package_type: 'custom',
      key: package_name,
      implementation_fee: implementation_fee,
      business_required: true,
      billing_category: billing_category,
      interval: interval,
      min_recommended_price: ((amount * 2).round(-1) - 1)
    )
  end

  def fetch_package_subscription
    return package_subscription if package_subscription

    build_package_subscription(
      package_name: package_name, package_type: :custom
    )
  end

  def white_glove_service_enabled?
    false
  end

  def addons; end

  def agency?
    agency.present?
  end

  def business?
    business.present?
  end

  def addons
    []
  end

  def ala_carte?
    false
  end

  def key
    'custom'
  end

  def plan_switch_enabled?(plan_key = nil)
    false
  end

  def quantity_enabled?
    false
  end

  def funnel_platform_required?
    false
  end

  private

  def create_stripe_plan
    return if charge?

    plan = Stripe::Plan.create({
      amount: (amount.to_f * 100).to_i,
      interval: interval,
      product: {
        name: product_name,
        statement_descriptor: product_name.truncate(22)
      },
      currency: 'usd'
    })
    self.stripe_plan = plan.id
  rescue => e
    self.errors.add(:base, e.message)
    throw(:abort)
  end

  def set_package_name
    self.package_name = product_name.parameterize.underscore
  end

  def product_name
    "Custom Package - #{name}"
  end

  def interval
    { subscription: 'month', charge: 'one-time' }[billing_category.to_sym]
  end
end
