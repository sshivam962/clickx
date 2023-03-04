# frozen_string_literal: true

module AffiliatePartnerHelper
  def ap_earnings(subscriptions)
    (subscriptions.sum(&:amount) * ENV['AP_PERCENTAGE'].to_i)/100
  end
end
