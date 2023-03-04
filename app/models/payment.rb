# frozen_string_literal: true
class Payment < ApplicationRecord
  acts_as_paranoid

  belongs_to :agency
  belongs_to :business, optional: true
  belongs_to :custom_package, optional: true
  belongs_to :package_subscription, optional: true
  belongs_to :payment_link, optional: true
  enum billing_category: %i[subscription charge]
end
