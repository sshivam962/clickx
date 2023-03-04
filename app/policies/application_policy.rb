class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, 'must be logged in' unless user
    @user = user
    @record = record
  end

  def full_access?
    user.full_access?
  end

  def agencies?
    full_access? || user.has_role?(:agencies)
  end

  def partner_search?
    full_access? || user.has_role?(:partner_search)
  end

  def clients?
    full_access? || user.has_role?(:clients)
  end

  def archived_clients?
    full_access? || user.has_role?(:archived_clients)
  end

  def demo_agency?
    full_access? || user.has_role?(:demo_agency)
  end

  def welcome_banner?
    full_access? || user.has_role?(:welcome_banner)
  end

  def archived_agencies?
    full_access? || user.has_role?(:archived_agencies)
  end

  def verified_domains_agencies?
    full_access? || user.has_role?(:verified_domains_agencies)
  end

  def leads?
    full_access? || user.has_role?(:leads)
  end

  def agency_academy?
    full_access? || user.has_role?(:agency_academy)
  end

  def case_studies?
    full_access? || user.has_role?(:case_studies)
  end

  def portfolio?
    full_access? || user.has_role?(:portfolio)
  end

  def faq?
    full_access? || user.has_role?(:faq)
  end

  def documents?
    full_access? || user.has_role?(:documents)
  end

  def client_academy?
    full_access? || user.has_role?(:client_academy)
  end

  def admin_academy?
    admin_users? || user.has_role?(:admin_academy)
  end

  def manage_admin_academy?
    full_access? || user.has_role?(:manage_admin_academy)
  end

  def admin_faq?
    admin_users? || user.has_role?(:admin_faq)
  end

  def admin_manage_faqs?
    full_access? || user.has_role?(:admin_manage_faq)
  end

  def questionnaire?
    full_access? || user.has_role?(:questionnaire)
  end

  def content_settings?
    full_access? || user.has_role?(:content_settings)
  end

  def third_party_integrations?
    full_access? || user.has_role?(:third_party_integrations)
  end

  def location_map?
    full_access? || user.has_role?(:location_map)
  end

  def manage_labels?
    full_access? || user.has_role?(:manage_labels)
  end

  def reports?
    full_access? || user.has_role?(:reports)
  end

  def email_templates?
    full_access? || user.has_role?(:email_templates)
  end

  def emails?
    admin_users? || user.has_role?(:email)
  end

  def messages?
    full_access? || user.has_role?(:messages)
  end

  def message_report?
    full_access? || user.has_role?(:message_report)
  end

  def onboarding_checklists?
    full_access? || user.has_role?(:onboarding_checklists)
  end

  def social_media_prompts?
    full_access? || user.has_role?(:social_media_prompts)
  end

  def agency_facebook_ads?
    full_access? || user.has_role?(:facebook_ads)
  end

  def agency_social_posts?
    full_access? || user.has_role?(:social_posts)
  end

  def agency_value_hooks?
    full_access? || user.has_role?(:value_hooks)
  end

  def agency_plug_and_play_ads?
    full_access? || user.has_role?(:social_media_ads)
  end

  def billing?
    full_access? || user.has_role?(:billing)
  end

  def agency_package_subscriptions?
    full_access? || user.has_role?(:agency_package_subscriptions)
  end

  def client_package_subscriptions?
    full_access? || user.has_role?(:client_package_subscriptions)
  end

  def smb_package_subscriptions?
    full_access? || user.has_role?(:smb_package_subscriptions)
  end

  def custom_packages?
    full_access? || user.has_role?(:custom_packages)
  end

  def packages?
    full_access? || user.has_role?(:packages)
  end

  def agency_signup_links?
    full_access? || user.has_role?(:agency_signup_links)
  end

  def business_signup_links?
    full_access? || user.has_role?(:business_signup_links)
  end

  def payment_links?
     full_access? || user.has_role?(:payment_links)
  end

  def admin_users?
     full_access? || user.has_role?(:admin_users)
  end

  def archived_users?
    full_access? || user.has_role?(:archived_users)
  end

  def contractors?
    full_access? || user.has_role?(:contractors)
  end

  def contractors_upload_user?
    full_access? || user.has_role?(:contractors_upload_user)
  end

  def client_questionnaire?
    full_access? || user.has_role?(:client_questionnaire)
  end

  def lead_strategy?
    full_access? || user.has_role?(:lead_strategy)
  end

  def lead_strategy_item?
    full_access? || user.has_role?(:lead_strategy_item)
  end

  def agency_settings?
    full_access? || user.has_role?(:agency_settings)
  end

  def onboarding_procedures?
    full_access? ||  user.has_role?(:onboarding_procedures)
  end

  def partner_search?
    full_access? ||  user.has_role?(:partner_search)
  end

  def funnel_pages?
    full_access? ||  user.has_role?(:funnel_pages)
  end

  def super_admin?
    full_access? || user.super_admin?
  end

  def outscraper_data?
    full_access? ||  user.has_role?(:outscraper_data)
  end

  def outscraper_bulk_upload?
    full_access? ||  user.has_role?(:outscraper_bulk_upload)
  end

  def blacklisted_domains?
    full_access? ||  user.has_role?(:blacklisted_domains)
  end

  def email_sents?
    full_access? ||  user.has_role?(:email_sents)
  end

  def mailgun_subdomains?
    full_access? ||  user.has_role?(:mailgun_subdomains)
  end

  def outscraper_categories?
    full_access? ||  user.has_role?(:outscraper_categories)
  end
end
