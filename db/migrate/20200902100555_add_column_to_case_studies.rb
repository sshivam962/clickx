class AddColumnToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :status, :integer, default: 0

    CaseStudy.update_all(status: 1)
  end
end
