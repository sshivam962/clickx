class AddExpeditedOnboardingToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :expedited_onboarding, :boolean, default: false
  end
end
