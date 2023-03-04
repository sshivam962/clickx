class AddExpeditedOnboardingFeeToPackageSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :package_subscriptions, :expedited_onboarding_fee, :float
  end
end
