class CreateOnboardingChecklist < ActiveRecord::Migration[5.1]
  def change
    create_table :onboarding_checklists do |t|
      t.string :title
    end
  end
end
