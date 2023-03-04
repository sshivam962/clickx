class ChangeOnboardingChecklistToBeIntegerInAgencies < ActiveRecord::Migration[5.1]
  def change
  	change_column :agencies, :onboarding_checklist, :integer, array: true, using: 'array[onboarding_checklist]::INTEGER[]'
  end
end
