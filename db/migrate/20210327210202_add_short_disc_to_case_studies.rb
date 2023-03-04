class AddShortDiscToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :short_desc, :string
  end
end
