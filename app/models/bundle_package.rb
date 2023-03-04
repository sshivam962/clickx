class BundlePackage < ApplicationRecord
  validates :key, uniqueness: true
  has_many :bundle_plans, dependent: :destroy

  enum category: %i[agency business]

  def white_glove_service_enabled?
    false
  end

  def white_glove_plan
    BundlePackage.includes(:bundle_plans).find_by(key: 'white_glove_service')
                 .bundle_plans.find_by(key: self.white_glove_fees.to_i.to_s)
  end

  def expedited_onboarding_fee
    implementation_fee
  end

  def funnel_platform_required?
    bundle_plans.where('key LIKE ?', "%funnel_development%").exists?
  end

  def addons
    addon_keys = {
      fb_ads_funnel_development: ['zapier_integration'],
      fb_ads_pro_google_ads_pro: ['zapier_integration'],
      google_ads_landing_page: ['zapier_integration'],
      google_ads_pro_fb_ads_starter: ['zapier_integration'],
      google_fb_ads: ['zapier_integration'],
      national_seo_starter_google_ads_advanced: ['zapier_integration'],
      local_seo_facebook_jumpstart: ['zapier_integration'],
      local_seo_facebook_starter: ['zapier_integration'],
      google_ads_starter_funnel_development_starter: ['zapier_integration']
    }
    Plan.where(key: addon_keys[key.to_sym].to_a)
  end
end
