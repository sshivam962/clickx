# frozen_string_literal: true

namespace :seed_plans do
  desc 'Seed new fb and google plans'
  task new_fb_google: :environment do

    ActiveRecord::Base.transaction do
      #Change existing facebook plans to fixed facebook plans
      fb_package = Package.find_by(key: 'facebook_ads')
      new_fb_package = fb_package.dup

      fb_package.update(key: "fixed_facebook_ads")
      fb_package.plans.update(package_type: "fixed_facebook_ads")

      new_fb_package.save
      new_fb_package.plans.create(facebook_ads_plans)

      #delete google ads plans
      google_package = Package.find_by(key: 'google_ads')
      # google_package.plans.each do |plan|
      #   Stripe::Plan.delete(plan.stripe_plan)
      # end
      google_package.plans.destroy_all
      google_package.plans.create(google_ads_plans)

      fb_product =
        Stripe::Product.create({name: 'Facebook Ads', type: 'service'})
      google_product =
        Stripe::Product.create({name: 'Google Ads', type: 'service'})

      Plan.where(package_type: 'facebook_ads').each do |plan|
        puts plan.name
        Stripe::Plan.create({
          amount: (plan.amount * 100).to_i,
          interval: plan.interval,
          product: fb_product['id'],
          currency: 'usd',
          id: plan.stripe_plan
        })
      end

      Plan.where(package_type: 'google_ads').each do |plan|
        puts plan.name
        Stripe::Plan.create({
          amount: (plan.amount * 100).to_i,
          interval: plan.interval,
          product: google_product[:id],
          currency: 'usd',
          id: plan.stripe_plan
        })
      end
    end
  end

  task agency_website: :environment do
    ActiveRecord::Base.transaction do
      package =
        Package.create(
          key: 'agency_website',
          name: 'Agency Website'
        )
      plans = package.plans.create(website_plans)

      product =
        Stripe::Product.create(
          { name: 'Agency Website', type: 'service' }
        )
      plans.each do |plan|
        puts plan.name
        Stripe::Plan.create({
          nickname: plan.stripe_plan.titleize,
          amount: (plan.amount * 100).to_i,
          interval: plan.interval,
          product: product['id'],
          currency: 'usd',
          id: plan.stripe_plan
        })
      end
    end
  end

  def website_plans
    [
      { key: 'starter', amount: 25, onetime_charge: 399.0},
      { key: 'pro', amount: 25, onetime_charge: 899.0},
      { key: 'advanced', amount: 25, onetime_charge:1499.0 }
    ].map do |plan|
      plan_attributes('agency_website', plan, 'month', false)
    end
  end

  def facebook_ads_plans
    [
      {key: 'starter', amount: 899.0, min_recommended_price: 1100.0, implementation_fee: 500.0},
      {key: 'pro', amount: 1099.0, min_recommended_price: 1300.0, implementation_fee: 500.0},
      {key: 'advanced', amount: 1399.0, min_recommended_price: 1600.0, implementation_fee: 500.0},
      {key: 'starter_with_white_glove_service', amount: 1399.0, min_recommended_price: 1100.0, implementation_fee: 500.0},
      {key: 'pro_with_white_glove_service', amount: 1599.0, min_recommended_price: 1300.0, implementation_fee: 500.0},
      {key: 'advanced_with_white_glove_service', amount: 1899.0, min_recommended_price: 1600.0, implementation_fee: 500.0}
    ].map do |plan|
      plan_attributes('facebook_ads', plan, 'month', true)
    end
  end

  def google_ads_plans
    [
      {key: 'starter', amount: 899.0, min_recommended_price: 1100.0, implementation_fee: 500.0},
      {key: 'pro', amount: 1099.0, min_recommended_price: 1300.0, implementation_fee: 500.0},
      {key: 'advanced', amount: 1399.0, min_recommended_price: 1600.0, implementation_fee: 500.0},
      {key: 'starter_with_white_glove_service', amount:1399.0, min_recommended_price: 1100.0, implementation_fee: 500.0},
      {key: 'pro_with_white_glove_service', amount: 1599.0, min_recommended_price: 1300.0, implementation_fee: 500.0},
      {key: 'advanced_with_white_glove_service', amount: 1899.0, min_recommended_price: 1600.0, implementation_fee: 500.0}
    ].map do |plan|
      plan_attributes('google_ads', plan, 'month', true)
    end
  end

  def plan_attributes(package_key, plan, interval, businesses_required)
    billing_category = interval.eql?('month') ? 'subscription' : 'charge'
    {
      name: "#{package_key}_#{plan[:key]}".titleize,
      key: plan[:key],
      product_name: package_key.titleize,
      amount: plan[:amount],
      billing_category: billing_category,
      interval: interval,
      stripe_plan: "#{package_key}_#{plan[:key]}",
      package_name: package_key.titleize,
      package_type: package_key,
      implementation_fee: plan[:implementation_fee],
      min_recommended_price: plan[:min_recommended_price],
      business_required: businesses_required,
      onetime_charge: plan[:onetime_charge]
    }
  end
end
