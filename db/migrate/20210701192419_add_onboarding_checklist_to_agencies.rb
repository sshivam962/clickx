class AddOnboardingChecklistToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :onboarding_checklist, :text, array: true
  end
end
