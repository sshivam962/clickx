# frozen_string_literal: true

class PaymentDetail < ApplicationRecord
  belongs_to :business

  def process_payment(amount, description, email, card_token, stripe_customer_id)
    unless stripe_customer_id
      customer = Stripe::Customer.create email: email,
                                         card: card_token
      stripe_customer_id = customer.id
    end
    charge = Stripe::Charge.create customer: stripe_customer_id,
                                   amount: (amount.to_f * 100).to_i,
                                   description: description,
                                   currency: 'usd'

    card_count = PaymentDetail.where(stripe_customer_id: stripe_customer_id).count
    if card_count == 0
      if charge.class == Stripe::Charge
        if charge.status == 'succeeded' || charge.status == 'paid'
          charge.save_card = true
          charge.stripe_customer_id = stripe_customer_id
          return charge
        end
      end
    else
      charge.save_card = false
      return charge
    end
  rescue StandardError => e
    return e
  end
end
