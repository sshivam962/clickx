class CreateBusinessOnboardingProcedures < ActiveRecord::Migration[5.1]
  def change
    create_table :business_onboarding_procedures do |t|
      t.references         :business
      t.references         :onboarding_procedure
      t.timestamps
    end
  end
end