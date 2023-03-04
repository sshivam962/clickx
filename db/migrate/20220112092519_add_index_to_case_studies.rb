class AddIndexToCaseStudies < ActiveRecord::Migration[5.1]
  def change
  	add_index :case_studies, :agency_id
  end
end
