class StripeCredential < ApplicationRecord
  belongs_to :agency

  validates :publishable_key, presence: true
  validates :secret_key, presence: true
  validates :payment_links_product_id, presence: true

  before_validation :create_stripe_product

  def create_stripe_product
    return unless stripe_product_required?

    product =
      Stripe::Product.create(
        { name: 'Payment Links', type: 'service' },
        api_key: secret_key
      )
    self.payment_links_product_id = product['id']
  end

  def stripe_product_required?
    will_save_change_to_secret_key? ||
    will_save_change_to_publishable_key? ||
    payment_links_product_id.blank?
  end
end
