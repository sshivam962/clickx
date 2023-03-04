class AddInternalNoteToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :internal_note, :text
  end
end
