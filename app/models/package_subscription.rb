# frozen_string_literal: true
class PackageSubscription < ApplicationRecord
  acts_as_paranoid

  belongs_to :agency
  belongs_to :business, -> { with_deleted }, optional: true
  belongs_to :custom_package, optional: true
  has_many :payments
  has_many :onboarding_procedures
  enum billing_category: %i[subscription charge]
  enum billing_type: %i[manual stripe]
  enum package_type: %i[
                        custom agency_infrastructure facebook_ads google_ads
                        social_media digital_pr ala_carte local_seo
                        funnel_development fixed_facebook_ads seo_services
                        agency_website g_suite agency_ala_carte business_signup
                        agency_facebook_ads agency_google_ads linkedin_ads
                        jumpstart_google_ads jumpstart_facebook_ads
                        jumpstart_seo agency_domain_management bundle
                        growth_coaching sales_support addons logo_design
                        sales_coaching mastery_coaching blog_creation
                        email_sequence_creation facebook_ecommerce_ads programmatic_and_geo_fencing 
                        brand_refinement_website_content consulting generate_lead_strategy
                      ]

  scope :active, -> { where(status: %w[active succeeded trialing]) }

  scope :agency_subscriptions, -> { where(recipient_type: 'agency') }
  scope :client_subscriptions, -> { where(recipient_type: 'client') }
  scope :smb_subscriptions, -> { where(recipient_type: 'smb') }
  scope :non_growth, -> { where.not(package_type: 'agency_infrastructure') }
  scope :search_by_agencies_name, ->(name) { where("lower(agencies.name) ILIKE ?", "%#{name}%") }

  scope :priority_order, -> { order("CASE package_subscriptions.status
                                      WHEN 'active'    THEN '1'
                                      WHEN 'succeeded' THEN '2'
                                      WHEN 'trialing'  THEN '3'
                                      WHEN 'cancelled' THEN '4'
                                    END") }

  def plan_name
    package_name.split('_').last.titleize
  end

  def package
    return nil if package_class.blank? || package_id.blank?

    package_class.classify.constantize.find package_id
  end
end
