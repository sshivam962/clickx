class AddAgencyIdToOnboardingProcedures < ActiveRecord::Migration[5.1]
  def change
    add_column :onboarding_procedures, :agency_id, :integer
  end
end
