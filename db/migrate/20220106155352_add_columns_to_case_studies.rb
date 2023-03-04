class AddColumnsToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :agency_id, :integer, default: 0
  end
end