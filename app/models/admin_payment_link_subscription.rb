class AdminPaymentLinkSubscription < ApplicationRecord
  belongs_to :admin_plan, class_name: 'AdminPaymentLinkPlan', foreign_key: 'admin_payment_link_plan_id'
end
