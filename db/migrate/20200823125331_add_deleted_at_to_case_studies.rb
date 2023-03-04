class AddDeletedAtToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :deleted_at, :datetime
  end
end
