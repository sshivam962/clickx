class DropBusinessOnboardingProcedures < ActiveRecord::Migration[5.1]
  def self.up
    drop_table :business_onboarding_procedures
  end

  def self.down
    create_table :business_onboarding_procedures do |t|
      t.references         :business
      t.references         :onboarding_procedure
      t.timestamps
    end
  end
end
