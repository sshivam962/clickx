class AddGraderLogoToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :grader_logo, :string
  end
end
