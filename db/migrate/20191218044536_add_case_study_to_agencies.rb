class AddCaseStudyToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :case_study, :boolean, default: false
  end
end
