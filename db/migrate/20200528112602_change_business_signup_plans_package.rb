class ChangeBusinessSignupPlansPackage < ActiveRecord::Migration[5.1]
  def up
    package = Package.find_by(key: 'business_signup')
    internal_package = Internal::Package.create(package.slice(:name, :key))
    package.plans.each do |plan|
      internal_package.plans.create(
        plan.slice(
          :name, :key, :product_name, :amount, :billing_category, :stripe_plan,
          :package_name, :package_type, :interval
        )
      )
    end
    package.destroy
  end

  def down
    internal_package = Internal::Package.find_by(key: 'business_signup')
    package = Package.create(internal_package.slice(:name, :key))
    internal_package.plans.each do |plan|
      package.plans.create(
        plan.slice(
          :name, :key, :product_name, :amount, :billing_category, :stripe_plan,
          :package_name, :package_type, :interval
        ).merge(business_required: true)
      )
    end
    internal_package.destroy
  end
end
