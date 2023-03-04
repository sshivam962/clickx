Internal::Package.create!([
  {
    name: "Facebook Ads",
    key: "facebook_ads",
    sales_pitch: nil,
    sales_pitch_enabled: false
  },
  {
    name: "Google Ads",
    key: "google_ads",
    sales_pitch: nil,
    sales_pitch_enabled: false
  },
  {
    name: "Social Media",
    key: "social_media",
    sales_pitch: nil,
    sales_pitch_enabled: false
  },
  {
    name: "Digital Pr",
    key: "digital_pr",
    sales_pitch: nil,
    sales_pitch_enabled: false
  },
  {
    name: "Ala Carte",
    key: "ala_carte",
    sales_pitch: nil,
    sales_pitch_enabled: false
  },
  {
    name: "Local Seo",
    key: "local_seo",
    sales_pitch: nil,
    sales_pitch_enabled: false
  },
  {
    name: "Business Signup",
    key: "business_signup",
    sales_pitch: nil,
    sales_pitch_enabled: false
  }
])


package = Internal::Package.find_by(key: 'facebook_ads')
Internal::Plan.create!([
  {
    name: "Clickx Facebook Ads",
    key: "starter",
    product_name: "Clickx Facebook Ads",
    amount: 997.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_facebook_ads_starter",
    package_name: "clickx_facebook_ads_starter",
    package_type: "facebook_ads",
    implementation_fee: 500.0,
    display_tag: nil,
    clickx_package_id: package.id
  }
])
package = Internal::Package.find_by(key: 'google_ads')
Internal::Plan.create!([
  {
    name: "Clickx Google Ads",
    key: "starter",
    product_name: "Clickx Google Ads",
    amount: 997.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_google_ads_starter",
    package_name: "clickx_google_ads_starter",
    package_type: "google_ads",
    implementation_fee: 500.0,
    display_tag: nil,
    clickx_package_id: package.id
  }
])
package = Internal::Package.find_by(key: 'social_media')
Internal::Plan.create!([
  {
    name: "Clickx Social Media Starter",
    key: "starter",
    product_name: "Clickx Social Media Starter",
    amount: 997.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_social_media_starter",
    package_name: "clickx_social_media_starter",
    package_type: "social_media",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Social Media Pro",
    key: "pro",
    product_name: "Clickx Social Media Pro",
    amount: 1497.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_social_media_pro",
    package_name: "clickx_social_media_pro",
    package_type: "social_media",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Social Media Advanced",
    key: "advanced",
    product_name: "Clickx Social Media Advanced",
    amount: 2497.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_social_media_advanced",
    package_name: "clickx_social_media_advanced",
    package_type: "social_media",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  }
])
package = Internal::Package.find_by(key: 'digital_pr')
Internal::Plan.create!([
  {
    name: "Clickx Digital PR Starter",
    key: "starter",
    product_name: "Clickx Digital PR Starter",
    amount: 997.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_digital_pr_starter",
    package_name: "clickx_digital_pr_starter",
    package_type: "digital_pr",
    implementation_fee: 500.0,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Digital PR Pro",
    key: "pro",
    product_name: "Clickx Digital PR Pro",
    amount: 1997.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_digital_pr_pro",
    package_name: "clickx_digital_pr_pro",
    package_type: "digital_pr",
    implementation_fee: 500.0,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Digital PR Advanced",
    key: "advanced",
    product_name: "Clickx Digital PR Advanced",
    amount: 2497.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_digital_pr_advanced",
    package_name: "clickx_digital_pr_advanced",
    package_type: "digital_pr",
    implementation_fee: 500.0,
    display_tag: nil,
    clickx_package_id: package.id
  }
])
package = Internal::Package.find_by(key: 'local_seo')
Internal::Plan.create!([
  {
    name: "Clickx Local SEO Starter",
    key: "starter",
    product_name: "Clickx Local SEO Starter",
    amount: 997.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_local_seo_starter",
    package_name: "clickx_local_seo_starter",
    package_type: "local_seo",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Local SEO Pro",
    key: "pro",
    product_name: "Clickx Local SEO Pro",
    amount: 1497.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_local_seo_pro",
    package_name: "clickx_local_seo_pro",
    package_type: "local_seo",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Local SEO Advanced",
    key: "advanced",
    product_name: "Clickx Local SEO Advanced",
    amount: 2497.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "clickx_local_seo_advanced",
    package_name: "clickx_local_seo_advanced",
    package_type: "local_seo",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  }
])
package = Internal::Package.find_by(key: 'google_ads')
Internal::Plan.create!([
  {
    name: "Clickx SEO Audit - Lite",
    key: "seo_audit_lite",
    product_name: "Clickx SEO Audit - Lite",
    amount: 497.0,
    billing_category: "charge",
    interval: "one-time",
    stripe_plan: nil,
    package_name: "clickx_ala_carte_seo_audit_lite",
    package_type: "ala_carte",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Google Ads Audit",
    key: "google_ads_audit",
    product_name: "Clickx Google Ads Audit",
    amount: 497.0,
    billing_category: "charge",
    interval: "one-time",
    stripe_plan: nil,
    package_name: "clickx_ala_carte_google_ads_audit",
    package_type: "ala_carte",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Facebook Ads Audit",
    key: "facebook_ads_audit",
    product_name: "Clickx Facebook Ads Audit",
    amount: 497.0,
    billing_category: "charge",
    interval: "one-time",
    stripe_plan: nil,
    package_name: "clickx_ala_carte_facebook_ads_audit",
    package_type: "ala_carte",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx À La Carte PPC Landing Page",
    key: "ppc_landing_page",
    product_name: "Clickx À La Carte PPC Landing Page",
    amount: 497.0,
    billing_category: "charge",
    interval: "one-time",
    stripe_plan: nil,
    package_name: "clickx_ala_carte_ppc_landing_page",
    package_type: "ala_carte",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx À La Carte Custom Landing Page",
    key: "custom_landing_page",
    product_name: "Clickx À La Carte Custom Landing Page",
    amount: 1500.0,
    billing_category: "charge",
    interval: "one-time",
    stripe_plan: nil,
    package_name: "clickx_ala_carte_custom_landing_page",
    package_type: "ala_carte",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  },
  {
    name: "Clickx Call Tracking",
    key: "call_tracking",
    product_name: "Clickx Call Tracking",
    amount: 49.0,
    billing_category: "charge",
    interval: "month",
    stripe_plan: "clickx_ala_carte_call_tracking",
    package_name: "clickx_ala_carte_call_tracking",
    package_type: "ala_carte",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  }
])
package = Internal::Package.find_by(key: 'business_signup')
Internal::Plan.create!([
  {
    name: "Business Signup Starter",
    key: "starter",
    product_name: "Business Signup Starter",
    amount: 99.0,
    billing_category: "subscription",
    interval: "month",
    stripe_plan: "business_signup_starter",
    package_name: "business_signup_starter",
    package_type: "business_signup",
    implementation_fee: nil,
    display_tag: nil,
    clickx_package_id: package.id
  }
])
