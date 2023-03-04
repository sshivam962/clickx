class AddBusinessIdToOnboardingProcedures < ActiveRecord::Migration[5.1]
  def change
    add_column :onboarding_procedures, :business_id, :integer
  end
end
