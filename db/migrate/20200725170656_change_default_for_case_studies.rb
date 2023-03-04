class ChangeDefaultForCaseStudies < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:agencies, :case_study_enabled, false)
  end
end
