class SeedClickxPackages < ActiveRecord::Migration[5.1]
  def up
    packages.each do |name, plans|
      package = Internal::Package.create(name: name.to_s.titleize, key: name)
      plans.each do |key, plan|
        plan = package.plans.create(plan.merge(key: key))
        next if name.eql?(:ala_carte)

        Stripe::Plan.create({
          amount: (plan.amount * 100).to_i,
          interval: plan.interval,
          product: {
            name: plan.product_name,
          },
          currency: 'usd',
          id: plan.stripe_plan,
        }) rescue nil
      end
    end
  end

  def down
    Internal::Package.destroy_all
  end

  private

  def packages
    {
      facebook_ads: {
        starter: {
          name: 'Clickx Facebook Ads',
          product_name: 'Clickx Facebook Ads',
          amount: 997,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_facebook_ads_starter',
          package_name: 'clickx_facebook_ads_starter',
          package_type: 'google_ads',
          implementation_fee: 500
        }
      },
      google_ads: {
        starter: {
          name: 'Clickx Google Ads',
          product_name: 'Clickx Google Ads',
          amount: 997,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_google_ads_starter',
          package_name: 'clickx_google_ads_starter',
          package_type: 'google_ads',
          implementation_fee: 500
        }
      },
      social_media: {
        starter: {
          name: 'Clickx Social Media Starter',
          product_name: 'Clickx Social Media Starter',
          amount: 997,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_social_media_starter',
          package_name: 'clickx_social_media_starter',
          package_type: 'social_media'
        },
        pro: {
          name: 'Clickx Social Media Pro',
          product_name: 'Clickx Social Media Pro',
          amount: 1497,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_social_media_pro',
          package_name: 'clickx_social_media_pro',
          package_type: 'social_media'
        },
        advanced: {
          name: 'Clickx Social Media Advanced',
          product_name: 'Clickx Social Media Advanced',
          amount: 2497,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_social_media_advanced',
          package_name: 'clickx_social_media_advanced',
          package_type: 'social_media'
        }
      },
      digital_pr: {
        starter: {
          name: 'Clickx Digital PR Starter',
          product_name: 'Clickx Digital PR Starter',
          amount: 997,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_digital_pr_starter',
          package_name: 'clickx_digital_pr_starter',
          package_type: 'digital_pr',
          implementation_fee: 500
        },
        pro: {
          name: 'Clickx Digital PR Pro',
          product_name: 'Clickx Digital PR Pro',
          amount: 1997,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_digital_pr_pro',
          package_name: 'clickx_digital_pr_pro',
          package_type: 'digital_pr',
          implementation_fee: 500
        },
        advanced: {
          name: 'Clickx Digital PR Advanced',
          product_name: 'Clickx Digital PR Advanced',
          amount: 2497,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_digital_pr_advanced',
          package_name: 'clickx_digital_pr_advanced',
          package_type: 'digital_pr',
          implementation_fee: 500
        }
      },
      ala_carte: {
        seo_audit_lite: {
          name: 'Clickx SEO Audit - Lite',
          product_name: 'Clickx SEO Audit - Lite',
          amount: 497,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'clickx_ala_carte_seo_audit_lite',
          package_type: 'ala_carte'
        },
        google_ads_audit: {
          name: 'Clickx Google Ads Audit',
          product_name: 'Clickx Google Ads Audit',
          amount: 497,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'clickx_ala_carte_google_ads_audit',
          package_type: 'ala_carte'
        },
        facebook_ads_audit: {
          name: 'Clickx Facebook Ads Audit',
          product_name: 'Clickx Facebook Ads Audit',
          amount: 497,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'clickx_ala_carte_facebook_ads_audit',
          package_type: 'ala_carte'
        },
        ppc_landing_page: {
          name: 'Clickx À La Carte PPC Landing Page',
          product_name: 'Clickx À La Carte PPC Landing Page',
          amount: 497,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'clickx_ala_carte_ppc_landing_page',
          package_type: 'ala_carte'
        },
        custom_landing_page: {
          name: 'Clickx À La Carte Custom Landing Page',
          product_name: 'Clickx À La Carte Custom Landing Page',
          amount: 1497,
          billing_category: 'charge',
          interval: 'one-time',
          package_name: 'clickx_ala_carte_custom_landing_page',
          package_type: 'ala_carte'
        }
      },
      local_seo: {
        starter: {
          name: 'Clickx Local SEO Starter',
          product_name: 'Clickx Local SEO Starter',
          amount: 997,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_local_seo_starter',
          package_name: 'clickx_local_seo_starter',
          package_type: 'local_seo'
        },
        pro: {
          name: 'Clickx Local SEO Pro',
          product_name: 'Clickx Local SEO Pro',
          amount: 1497,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_local_seo_pro',
          package_name: 'clickx_local_seo_pro',
          package_type: 'local_seo'
        },
        advanced: {
          name: 'Clickx Local SEO Advanced',
          product_name: 'Clickx Local SEO Advanced',
          amount: 2497,
          billing_category: 'subscription',
          interval: 'month',
          stripe_plan: 'clickx_local_seo_advanced',
          package_name: 'clickx_local_seo_advanced',
          package_type: 'local_seo'
        }
      }
    }
  end
end
