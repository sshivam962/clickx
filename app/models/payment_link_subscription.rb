class PaymentLinkSubscription < ApplicationRecord
  belongs_to :agency
  belongs_to :plan, class_name: 'PaymentLinkPlan', foreign_key: 'payment_link_plan_id'
end
