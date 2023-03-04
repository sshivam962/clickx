# frozen_string_literal: true

class AgencyPolicy
  attr_reader :user, :agency

  def initialize(user, agency)
    @user = user
    @agency = agency
  end

  def manage?
    agency == user.ownable || user.super_admin?
  end

  def visible?
    user.super_admin? ||
      agency == user.ownable ||
      agency.business_users.ids.include?(user.id)
  end

  def settings?
    manage?
  end

  def profile?
    manage?
  end

  #def documents?
    #agency.white_labeled?
  #end

  def case_study?
    (agency.case_study_limited_access? || agency.case_study_enabled?) && paid?
  end

  #def portfolio?
    #agency.portfolio_enabled?
  #end

  def plans?
    agency.plans_enabled? && paid?
  end

  # def courses?
  #   agency.white_labeled?
  # end

  def paid?
    agency.has_active_subscription?
  end

  #####Agency sidebar permission#####

  def leads?
    user.agency_super_admin? || user.has_role?(:leads_agency_permission)
  end

  def packages?
    user.agency_super_admin? || user.has_role?(:packages_agency_permission)
  end

  def grader_reports?
    user.agency_super_admin? || user.has_role?(:grader_reports_agency_permission)
  end

  def roi?
    user.agency_super_admin? || user.has_role?(:roi_agency_permission)
  end

  def industries?
    user.agency_super_admin? || user.has_role?(:industries_agency_permission)
  end

  def documents?
    agency.white_labeled? && (user.agency_super_admin? || user.has_role?(:documents_agency_permission))
  end

  def portfolio?
    (agency.portfolio_enabled? || agency.portfolio_limited_access?) && (user.agency_super_admin? || user.has_role?(:portfolio_agency_permission))
  end

  def projects?
    return true if user.ownable.abc?
    return false if ENV['NETWORK_PLATFORM'].blank?

    user.agency_super_admin? || user.has_role?(:projects_agency_permission)
  end

  def branding?
    user.agency_super_admin? || user.has_role?(:branding_agency_permission)
  end

  def badges?
    user.agency_super_admin? || user.has_role?(:badges_agency_permission)
  end

  def courses?
    agency.white_labeled? && (user.agency_super_admin? || user.has_role?(:courses_agency_permission))
  end

  def scale_program?
    agency.white_labeled? && agency.scale_program? && (user.agency_super_admin? || user.has_role?(:scale_program_agency_permission))
  end

  def payment_links?
    user.agency_super_admin? || user.has_role?(:payment_links_agency_permission)
  end

  def affiliate_dashboard?
    user.agency_super_admin? || user.has_role?(:affiliate_dashboard_agency_permission)
  end
  def agency_infrastructure?
    user.agency_super_admin? || user.has_role?(:agency_infrastructure_agency_permission)
  end

  def agency_website?
    user.agency_super_admin? || user.has_role?(:agency_website_agency_permission)
  end

  def agency_dfy_content?
    user.agency_super_admin? || user.has_role?(:agency_dfy_content_agency_permission)
  end

  def agency_facebook_ads?
    user.agency_super_admin? || user.has_role?(:agency_facebook_ads_agency_permission)
  end

  def agency_google_ads?
    user.agency_super_admin? || user.has_role?(:agency_google_ads_agency_permission)
  end

  def sales_coaching?
    user.agency_super_admin? || user.has_role?(:sales_coaching_agency_permission)
  end

  def support?
    user.agency_super_admin? || user.has_role?(:support_agency_permission)
  end

  def faqs?
    user.agency_super_admin? || user.has_role?(:faqs_agency_permission)
  end

  def community?
    user.agency_super_admin? || user.has_role?(:community_agency_permission)
  end

  def users?
    user.agency_super_admin?
  end
end
