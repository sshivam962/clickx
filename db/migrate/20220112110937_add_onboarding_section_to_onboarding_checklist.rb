class AddOnboardingSectionToOnboardingChecklist < ActiveRecord::Migration[5.1]
  def change
  	add_reference :onboarding_checklists, :onboarding_section, index: true
  end
end
