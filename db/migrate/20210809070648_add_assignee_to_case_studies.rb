class AddAssigneeToCaseStudies < ActiveRecord::Migration[5.1]
  def change
    add_reference :case_studies, :assignee, references: :users, index: true
  end
end
