class SeedAgencyAnnualPlans < ActiveRecord::Migration[5.1]
  def up
    package = Package.find_by(key: 'agency_infrastructure')
    package.plans.create(annual_plans)
  end

  def down
    Plan.where(stripe_plan: annual_plans.pluck(:stripe_plan)).destroy_all
  end

  private

  def annual_plans
    [
      {
        key: 'annual_starter',
        name: 'Annual Starter',
        product_name: 'Agency Infrastructure Annual Starter',
        amount: 999,
        billing_category: 'subscription',
        interval: 'year',
        stripe_plan: 'agency_infrastructure_annual_starter',
        package_name: 'agency_infrastructure_annual_starter',
        package_type: 'agency_infrastructure'
      },
      {
        key: 'annual_pro',
        name: 'Annual Pro',
        product_name: 'Agency Infrastructure Annual Pro',
        amount: 9999,
        billing_category: 'subscription',
        interval: 'year',
        stripe_plan: 'agency_infrastructure_annual_pro',
        package_name: 'agency_infrastructure_annual_pro',
        package_type: 'agency_infrastructure'
      },
      {
        key: 'annual_advanced',
        name: 'Annual Advanced',
        product_name: 'Agency Infrastructure Annual Advanced',
        amount: 24999,
        billing_category: 'subscription',
        interval: 'year',
        stripe_plan: 'agency_infrastructure_annual_advanced',
        package_name: 'agency_infrastructure_annual_advanced',
        package_type: 'agency_infrastructure'
      }
    ]
  end
end
