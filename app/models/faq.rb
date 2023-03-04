class Faq < ApplicationRecord
  SECTIONS = {
    'General' => 'general',
    'Facebook Ads' => 'facebook_ads',
    'Google Ads' => 'google_ads',
    'SEO Services' => 'seo_services',
    'Brand Building' => 'brand_building'
  }
  enum sections: SECTIONS.values

  acts_as_list scope: [:section]
end
