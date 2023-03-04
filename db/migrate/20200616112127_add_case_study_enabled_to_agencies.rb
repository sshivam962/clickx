class AddCaseStudyEnabledToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :case_study_enabled, :boolean, default: true
  end
end
