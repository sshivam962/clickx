class CreateOnboardingTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :onboarding_tasks do |t|
      t.string                  :title
      t.text                    :description
      t.text                    :task
      t.integer                 :position
      t.boolean                 :completed
      t.references              :onboarding_procedure
      t.timestamps
    end
  end
end
