class AddDefaultValueToCompletedInOnboardingTasks < ActiveRecord::Migration[5.1]
  def change
    change_column :onboarding_tasks, :completed, :boolean, default: false
  end
end
