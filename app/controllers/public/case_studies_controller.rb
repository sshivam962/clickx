# frozen_string_literal: true

class Public::CaseStudiesController < PublicController
  before_action :set_case_study
  before_action :set_agency
  before_action :ensure_access

  def show; end

  private

  def set_case_study
    @case_study ||= CaseStudy.find_obfuscated(params[:id])
  end

  def set_agency
    @agency ||= Agency.find_obfuscated(params[:agency_id])
  end

  def ensure_access
    return if @case_study&.has_access?(@agency.active_package_name)

    redirect_to ENV['PUBLIC_APP_DOMAIN']
  end
end
