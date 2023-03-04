class PaymentLinkPlan < ApplicationRecord
  acts_as_paranoid

  belongs_to :payment_link

  enum billing_category: %i[subscription charge]

  before_validation :create_stripe_plan

  def create_stripe_plan
    return unless subscription?
    return if stripe_plan_id.present?

    stripe_credential = payment_link.stripe_credential
    stripe_plan = Stripe::Plan.create(
      {
        interval: 'month',
        currency: 'usd',
        amount: price_in_cents,
        product: stripe_credential.payment_links_product_id,
        nickname: "#{payment_link.display_name} - #{description_line_1}, #{description_line_2}"
      },
      api_key: stripe_credential.secret_key
    )
    self.stripe_plan_id = stripe_plan['id']
  end

  def price_in_cents
    (amount * 100).to_i
  end

  def amount_in_currency
    ApplicationController.helpers.number_to_currency(amount, precision: 0)
  end

  def price_with_details
    if subscription?
      "Monthly Recurring Charge - #{amount_in_currency}/mo"
    else
      "One-Time Charge - #{amount_in_currency}"
    end
  end

  def interval
    subscription? ? 'month' : 'one-time'
  end
end
