# frozen_string_literal: true

class Agency::BundlePackagesController < Agency::BaseController

  def index
    @packages =
      BundlePackage.includes(:bundle_plans)
                   .where(bundle_plans: {white_glove_service: false})
                   .group_by(&:key)
  end
end

