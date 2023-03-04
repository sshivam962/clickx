class AddStatsToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :stat1_text, :string
    add_column :case_studies, :stat1_value, :string
    add_column :case_studies, :stat2_text, :string
    add_column :case_studies, :stat2_value, :string
    add_column :case_studies, :stat3_text, :string
    add_column :case_studies, :stat3_value, :string
  end
end
