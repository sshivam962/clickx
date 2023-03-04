class CreateOnboardingSection < ActiveRecord::Migration[5.1]
  def change
    create_table :onboarding_sections do |t|
      t.string :title
    end
  end
end
