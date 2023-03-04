class AddCategoryToPackages < ActiveRecord::Migration[5.1]
  def up
    add_column :packages, :category, :integer

    Package.where(
      key: %w[agency_infrastructure agency_website agency_ala_carte]
    ).update_all(category: :agency)

    Package.where.not(
      key: %w[agency_infrastructure agency_website agency_ala_carte]
    ).update_all(category: :business)
  end

  def down
    remove_column :packages, :category, :integer
  end
end

# package =
#   Package.create(
#     name: 'Business Signup', key: 'business_signup', category: :business
#   )
# package.plans.create(
#   name: "Business Signup Starter",
#   key: "starter",
#   product_name: "Business Signup Starter",
#   amount: 99.0,
#   billing_category: "subscription",
#   interval: "month",
#   stripe_plan: "business_signup_starter",
#   package_name: "business_signup_starter",
#   package_type: "business_signup",
#   implementation_fee: nil,
#   min_recommended_price: 99.0,
#   business_required: true
# )
# Stripe::Plan.create({
#   amount: (99 * 100).to_i,
#   interval: 'month',
#   product: {
#     name: 'Business Signup',
#   },
#   currency: 'usd',
#   id: 'business_signup_starter',
# })
