class RemoveLogoFromCaseStudies < ActiveRecord::Migration[5.1]
  def change
    remove_column :case_studies, :logo, :string
  end
end
