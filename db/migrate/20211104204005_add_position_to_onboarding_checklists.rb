class AddPositionToOnboardingChecklists < ActiveRecord::Migration[5.1]
  def change
    add_column :onboarding_checklists, :position, :integer
  end
end
