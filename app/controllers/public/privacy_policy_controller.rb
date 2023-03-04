# frozen_string_literal: true

class Public::PrivacyPolicyController < PublicController
  layout 'layouts/public/funnel_page'
  before_action :set_agency

  def index
    @privacy_policy = PrivacyPolicy.first
  end

  private

  def set_agency
    @agency = Agency.find(params[:agency_id])
  end
end
