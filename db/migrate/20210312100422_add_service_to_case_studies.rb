class AddServiceToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_column :case_studies, :service, :string
  end
end
