class AddPackageSubscriptionIdToOnboardingProcedures < ActiveRecord::Migration[5.1]
  def change
    add_column :onboarding_procedures, :package_subscription_id, :bigint
  end
end
