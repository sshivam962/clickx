# frozen_string_literal: true

module BundlePackageHelper
  def bundle_msrp_text package
    msrps =
      package.bundle_plans.map do |plan|
        msrp = in_currency(plan.min_recommended_price, current_agency.display_currency)
        msrp += plan.interval_text
      end
    "MSRP: #{msrps.join(' + ')}"
  end

  def bundle_setup_fee_text package
    amount = package.bundle_plans.sum(:onetime_charge)
    return unless amount&.positive?

    "One-Time Implementation Fee: #{in_currency(amount, current_agency.display_currency)}"
  end
end
