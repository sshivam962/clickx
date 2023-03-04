class AddDetailedDescriptionToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :detailed_description, :text
  end
end
