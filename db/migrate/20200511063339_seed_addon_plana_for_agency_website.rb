class SeedAddonPlanaForAgencyWebsite < ActiveRecord::Migration[5.1]
  def up
    package = Package.create(name: 'G Suite', key: 'g_suite')
    package.plans.create({
      key: 'basic',
      name: 'Basic',
      product_name: 'Agency G Suite Basic',
      amount: 9,
      billing_category: 'subscription',
      interval: 'month',
      stripe_plan: 'agency_g_suite_basic',
      package_name: 'agency_g_suite_basic',
      package_type: 'g_suite',
      implementation_fee: 99
    })

    package = Package.create(name: 'Agency Ala Carte', key: 'agency_ala_carte')
    package.plans.create({
      name: "Call Tracking",
      key: "call_tracking",
      product_name: "Agency À La Carte Call Tracking",
      amount: 49.0,
      billing_category: "subscription",
      interval: "month",
      stripe_plan: "agency_ala_carte_call_tracking",
      package_name: "agency_ala_carte_call_tracking",
      package_type: "agency_ala_carte",
      implementation_fee: nil
    })
  end

  def down
    Package.find_by(key: 'g_suite').destroy
    Package.find_by(key: 'agency_ala_carte').destroy
  end
end
