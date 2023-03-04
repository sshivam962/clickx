class SeedPackagesAndPlans < ActiveRecord::Migration[5.1]
  def up
    packages.each do |name, plans|
      package = Package.create(name: name.to_s.titleize, key: name)
      plans.each do |key, plan|
        package.plans.create(plan.merge(key: key))
      end
    end
  end

  def down
    Package.destroy_all
  end

  private

  def packages
    {
      agency_infrastructure: {
        starter: {
          name: 'Agency Infrastructure Starter',
          product_name: 'Agency Infrastructure Starter',
          amount: 99,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'agency_infrastructure_starter',
          package_name: 'agency_infrastructure_starter',
          package_type: 'agency_infrastructure',
          business_required: false
        },
        pro: {
          name: 'Agency Infrastructure Pro',
          product_name: 'Agency Infrastructure Pro',
          amount: 1000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'agency_infrastructure_pro',
          package_name: 'agency_infrastructure_pro',
          package_type: 'agency_infrastructure',
          business_required: false
        },
        advanced: {
          name: 'Agency Infrastructure Advanced',
          product_name: 'Agency Infrastructure Advanced',
          amount: 2500,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'agency_infrastructure_advanced',
          package_name: 'agency_infrastructure_advanced',
          package_type: 'agency_infrastructure',
          business_required: false
        }
      },
      facebook_ads: {
        up_to_1000: {
          name: 'Up to 1000',
          product_name: 'Facebook Ads Up to 1000',
          amount: 1000,
          min_recommended_price: 2000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'facebook_ads_up_to_1000',
          package_name: 'facebook_ads_up_to_1000',
          package_type: 'facebook_ads',
          implementation_fee: 500,
          business_required: true
        },
        from_1000_to_2000: {
          name: '1000 - 2000',
          product_name: 'Facebook Ads 1000 - 2000',
          amount: 1250,
          min_recommended_price: 2500,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'facebook_ads_from_1000_to_2000',
          package_name: 'facebook_ads_from_1000_to_2000',
          package_type: 'facebook_ads',
          implementation_fee: 500,
          business_required: true
        },
        from_2001_to_3000: {
          name: '2001 - 3000',
          product_name: 'Facebook Ads 2001 - 3000',
          amount: 1350,
          min_recommended_price: 2700,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'facebook_ads_from_2001_to_3000',
          package_name: 'facebook_ads_from_2001_to_3000',
          package_type: 'facebook_ads',
          implementation_fee: 500,
          business_required: true
        },
        from_3001_to_7500: {
          name: '3001 - 7500',
          product_name: 'Facebook Ads 3001 - 7500',
          display_tag: 'Most Popular',
          amount: 1500,
          min_recommended_price: 3000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'facebook_ads_from_3001_to_7500',
          package_name: 'facebook_ads_from_3001_to_7500',
          package_type: 'facebook_ads',
          implementation_fee: 500,
          business_required: true
        },
        from_7500_to_10000: {
          name: '7500 - 10000',
          product_name: 'Facebook Ads 7500 - 10000',
          amount: 2000,
          min_recommended_price: 4000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'facebook_ads_from_7500_to_10000',
          package_name: 'facebook_ads_from_7500_to_10000',
          package_type: 'facebook_ads',
          implementation_fee: 500,
          business_required: true
        }
      },
      google_ads: {
        starter: {
          name: 'Google Ads',
          product_name: 'Google Ads',
          amount: 1500,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'google_ads_starter',
          package_name: 'google_ads_starter',
          package_type: 'google_ads',
          implementation_fee: 500,
          business_required: true
        }
      },
      seo_services: {
        starter: {
          name: 'SEO Services Starter',
          product_name: 'SEO Services Starter',
          amount: 2000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'seo_services_starter',
          package_name: 'seo_services_starter',
          package_type: 'seo_services',
          business_required: true
        },
        pro: {
          name: 'SEO Services Pro',
          product_name: 'SEO Services Pro',
          amount: 3000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'seo_services_essential',
          package_name: 'seo_services_essential',
          package_type: 'seo_services',
          business_required: true
        },
        advanced: {
          name: 'SEO Services Advanced',
          product_name: 'SEO Services Advanced',
          amount: 5000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'seo_services_exceptional',
          package_name: 'seo_services_exceptional',
          package_type: 'seo_services',
          business_required: true
        }
      },
      funnel_development: {
        starter: {
          name: 'Funnel Development Starter',
          product_name: 'Funnel Development Starter',
          amount: 2000,
          billing_category: 'charge',
          interval: 'one-time',
          stripe_plan: 'funnel_development_starter',
          package_name: 'funnel_development_starter',
          package_type: 'funnel_development',
          business_required: true
        },
        pro: {
          name: 'Funnel Development Pro',
          product_name: 'Funnel Development Pro',
          amount: 3000,
          billing_category: 'charge',
          interval: 'one-time',
          stripe_plan: 'funnel_development_essential',
          package_name: 'funnel_development_essential',
          package_type: 'funnel_development',
          business_required: true
        },
        advanced: {
          name: 'Funnel Development Advanced',
          product_name: 'Funnel Development Advanced',
          amount: 5000,
          billing_category: 'charge',
          interval: 'one-time',
          stripe_plan: 'funnel_development_exceptional',
          package_name: 'funnel_development_exceptional',
          package_type: 'funnel_development',
          business_required: true
        }
      },
      social_media: {
        starter: {
          name: 'Social Media Starter',
          product_name: 'Social Media Starter',
          amount: 1500,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'social_media_starter',
          package_name: 'social_media_starter',
          package_type: 'social_media',
          business_required: true
        },
        pro: {
          name: 'Social Media Pro',
          product_name: 'Social Media Pro',
          amount: 2000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'social_media_pro',
          package_name: 'social_media_pro',
          package_type: 'social_media',
          business_required: true
        },
        advanced: {
          name: 'Social Media Advanced',
          product_name: 'Social Media Advanced',
          amount: 2500,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'social_media_advanced',
          package_name: 'social_media_advanced',
          package_type: 'social_media',
          business_required: true
        }
      },
      digital_pr: {
        starter: {
          name: 'Digital PR Starter',
          product_name: 'Digital PR Starter',
          amount: 1500,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'digital_pr_starter',
          package_name: 'digital_pr_starter',
          package_type: 'digital_pr',
          business_required: true
        },
        pro: {
          name: 'Digital PR Pro',
          product_name: 'Digital PR Pro',
          amount: 2000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'digital_pr_pro',
          package_name: 'digital_pr_pro',
          package_type: 'digital_pr',
          business_required: true
        },
        advanced: {
          name: 'Digital PR Advanced',
          product_name: 'Digital PR Advanced',
          amount: 2500,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'digital_pr_advanced',
          package_name: 'digital_pr_advanced',
          package_type: 'digital_pr',
          business_required: true
        }
      },
      ala_carte: {
        template_landing_page: {
          name: 'À La Carte Template Landing Page',
          product_name: 'À La Carte Template Landing Page',
          amount: 500,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'ala_carte_template_landing_page',
          package_type: 'ala_carte',
          business_required: true
        },
        custom_landing_page: {
          name: 'À La Carte Custom Landing Page',
          product_name: 'À La Carte Custom Landing Page',
          amount: 1500,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'ala_carte_custom_landing_page',
          package_type: 'ala_carte',
          business_required: true
        },
        ads_creatives: {
          name: 'À La Carte Ads Creatives',
          product_name: 'À La Carte Ads Creatives',
          amount: 500,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'ala_carte_ads_creatives',
          package_type: 'ala_carte',
          business_required: true
        },
        call_tracking: {
          name: 'À La Carte Call Tracking',
          product_name: 'À La Carte Call Tracking',
          amount: 50,
          billing_category: 'subscription',
          interval: 'month',
          package_name: 'ala_carte_call_tracking',
          package_type: 'ala_carte',
          stripe_plan: 'ala_carte_call_tracking',
          business_required: true
        },
        seo_audit_lite: {
          name: 'SEO Audit - Lite',
          product_name: 'SEO Audit - Lite',
          amount: 500,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'ala_carte_seo_audit_lite',
          package_type: 'ala_carte',
          business_required: true
        },
        seo_audit_advanced: {
          name: 'SEO Audit - Advanced',
          product_name: 'SEO Audit - Advanced',
          amount: 1000,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'ala_carte_seo_audit_advanced',
          package_type: 'ala_carte',
          business_required: true
        },
        google_ads_audit: {
          name: 'Google Ads Audit',
          product_name: 'Google Ads Audit',
          amount: 350,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'ala_carte_google_ads_audit',
          package_type: 'ala_carte',
          business_required: true
        },
        facebook_ads_audit: {
          name: 'Facebook Ads Audit',
          product_name: 'Facebook Ads Audit',
          amount: 350,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'ala_carte_facebook_ads_audit',
          package_type: 'ala_carte',
          business_required: true
        }
      },
      local_seo: {
        starter: {
          name: 'Local SEO Starter',
          product_name: 'Local SEO Starter',
          amount: 1000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'local_seo_starter',
          package_name: 'local_seo_starter',
          package_type: 'local_seo',
          business_required: true
        },
        pro: {
          name: 'Local SEO Pro',
          product_name: 'Local SEO Pro',
          amount: 1500,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'local_seo_pro',
          package_name: 'local_seo_pro',
          package_type: 'local_seo',
          business_required: true
        },
        advanced: {
          name: 'Local SEO Advanced',
          product_name: 'Local SEO Advanced',
          amount: 2000,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'local_seo_advanced',
          package_name: 'local_seo_advanced',
          package_type: 'local_seo',
          business_required: true
        }
      }
    }
  end
end
