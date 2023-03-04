class AddDomainToGraderReports < ActiveRecord::Migration[5.1]
  def change
    add_column :grader_reports, :domain, :string
  end
end
