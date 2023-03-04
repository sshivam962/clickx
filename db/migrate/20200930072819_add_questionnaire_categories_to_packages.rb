class AddQuestionnaireCategoriesToPackages < ActiveRecord::Migration[5.1]
  def change
    add_column :packages, :questionnaire_categories, :text, array: true, default: []
    add_column :bundle_packages, :questionnaire_categories, :text, array: true, default: []
    add_column :custom_packages, :questionnaire_categories, :text, array: true, default: []

    packages = {
      google_ads: ['Google Ads - Lead Gen', 'Google Ads - Ecommerce'],
      seo_services: ['Advanced SEO '],
      funnel_development: ['Funnels'],
      social_media: [],
      digital_pr: [],
      local_seo: ['Local SEO '],
      fixed_facebook_ads: ['Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce'],
      facebook_ads: ['Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce'],
      linkedin_ads: ['LinkedIn Ads'],
      jumpstart_google_ads: ['Google Ads - Lead Gen', 'Google Ads - Ecommerce'],
      jumpstart_facebook_ads: ['Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce'],
      jumpstart_seo: ['Local SEO ', 'Advanced SEO '],
    }

    packages.each do |key, cats|
      Package.find_by(key: key).update(questionnaire_categories: cats)
    end

    bundle_packages = {
      google_fb_ads: ['Google Ads - Lead Gen', 'Google Ads - Ecommerce', 'Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce'],
      fb_ads_funnel_development: ['Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce', 'Funnels'],
      google_ads_landing_page: ['Google Ads - Lead Gen', 'Google Ads - Ecommerce'],
      google_ads_pro_fb_ads_starter: ['Google Ads - Lead Gen', 'Google Ads - Ecommerce', 'Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce'],
      fb_ads_pro_google_ads_pro: ['Google Ads - Lead Gen', 'Google Ads - Ecommerce', 'Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce'],
      local_seo_facebook_starter: ['Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce', 'Local SEO '],
      local_seo_facebook_jumpstart: ['Facebook Ads - Lead Gen', 'Facebook Ads - Ecommerce', 'Local SEO ']
    }
    bundle_packages.each do |key, cats|
      BundlePackage.find_by(key: key).update(questionnaire_categories: cats)
    end
  end
end
