class CreateOnboardingProcedures < ActiveRecord::Migration[5.1]
  def change
    create_table :onboarding_procedures do |t|
      t.string             :title
      t.timestamps
    end
  end
end
