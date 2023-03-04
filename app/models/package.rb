class Package < ApplicationRecord
  has_many :plans, dependent: :destroy

  has_many :addon_plans, as: :resource
  has_many :addons, through: :addon_plans, source: :plan

  validates :key, uniqueness: true

  enum key: {
    agency_infrastructure: 'agency_infrastructure',
    ala_carte: 'ala_carte',
    google_ads: 'google_ads',
    seo_services: 'seo_services',
    funnel_development: 'funnel_development',
    social_media: 'social_media',
    digital_pr: 'digital_pr',
    local_seo: 'local_seo',
    fixed_facebook_ads: 'fixed_facebook_ads',
    facebook_ads: 'facebook_ads',
    agency_website: 'agency_website',
    g_suite: 'g_suite',
    agency_ala_carte: 'agency_ala_carte',
    agency_facebook_ads: 'agency_facebook_ads',
    agency_google_ads: 'agency_google_ads',
    logo_design: 'logo_design',
    linkedin_ads: 'linkedin_ads',
    jumpstart_google_ads: 'jumpstart_google_ads',
    jumpstart_facebook_ads: 'jumpstart_facebook_ads',
    jumpstart_seo: 'jumpstart_seo',
    agency_domain_management: 'agency_domain_management',
    growth_coaching: 'growth_coaching',
    sales_support: 'sales_support',
    addons: 'addons',
    sales_coaching: 'sales_coaching',
    mastery_coaching: 'mastery_coaching',
    blog_creation: 'blog_creation',
    email_sequence_creation: 'email_sequence_creation',
    facebook_ecommerce_ads: 'facebook_ecommerce_ads',
    programmatic_and_geo_fencing: 'programmatic_and_geo_fencing',
    brand_refinement_website_content: 'brand_refinement_website_content',
    consulting: 'consulting',
    generate_lead_strategy: 'generate_lead_strategy',
    web_dev_product: 'web_dev_product',
    agency_dfy_content: 'agency_dfy_content'
  }

  enum category: %i[agency business]

  scope :sales_pitch_enabled, -> { where(sales_pitch_enabled: true) }
  scope :preview, -> { where(key: preview_list.keys) }
  scope :growth, -> { find_by(key: :agency_infrastructure) }
  scope :client_packages, -> { where(key: CLIENT_PACKAGES) }

  CLIENT_PACKAGES = %w[
    ala_carte google_ads seo_services
    social_media local_seo facebook_ads generate_lead_strategy web_dev_product
  ]

  TYLER_CLIENT_PACKAGES = %w[
    ala_carte google_ads seo_services funnel_development
    local_seo facebook_ads linkedin_ads
  ]

  AGENCY_PACKAGES = %w[
    agency_infrastructure agency_website g_suite agency_ala_carte
    agency_facebook_ads agency_google_ads agency_dfy_content
  ]

  OPTIONAL_PACKAGES = %w[
    facebook_ecommerce_ads digital_pr linkedin_ads programmatic_and_geo_fencing funnel_development
  ]

  def white_glove_service_enabled?
    false
  end

  def quantity_enabled?
    %w[blog_creation email_sequence_creation brand_refinement_website_content consulting].include?(key)
  end

  def plan_switch_enabled?(plan_key = nil)
    %w[blog_creation].include?(key) ||
    Plan::CALL_TRACKING_PLANS.include?(plan_key)
  end

  def switch_plans plan_key = nil
    if Plan::CALL_TRACKING_PLANS.include?(plan_key)
      plans.where(key: Plan::CALL_TRACKING_PLANS).order(:amount)
    else
      plans.order(:amount)
    end
  end

  def lead_generation_plan
    plans.find_by(package_type: 'generate_lead_strategy')
  end

  def agency_dfy_content_plan
    plans.find_by(package_type: 'agency_dfy_content')
  end

  def item_name
    case key
    when 'blog_creation'
      'Blogs'
    when 'email_sequence_creation'
      'Emails'
    when 'brand_refinement_website_content'
      'Brand Refinement'
    when 'consulting'
      'Consulting'
    end
  end

  def funnel_platform_required?
    funnel_development?
  end

  def self.preview_list
    {
      agency_facebook_ads: 'agency/packages/growth',
      agency_google_ads: 'agency/packages/growth',
      agency_infrastructure: 'agency/packages/growth',
      agency_website: 'agency/packages/growth',
      agency_dfy_content: 'agency/packages/growth',
      ala_carte: 'agency/packages/ala_carte',
      digital_pr: 'agency/packages/digital_pr',
      facebook_ads: 'agency/packages/facebook_ads',
      funnel_development: 'agency/packages/funnel_development',
      google_ads: 'agency/packages/google_ads',
      linkedin_ads: 'agency/packages/linkedin_ads',
      local_seo: 'agency/packages/local_seo',
      mastery_coaching: 'agency/packages/growth',
      sales_coaching: 'agency/packages/growth',
      sales_support: 'agency/packages/growth',
      seo_services: 'agency/packages/seo_services',
      social_media: 'agency/packages/social_media',
      facebook_ecommerce_ads: 'agency/packages/facebook_ecommerce_ads'
    }
  end
end
