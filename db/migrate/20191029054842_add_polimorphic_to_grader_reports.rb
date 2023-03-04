class AddPolimorphicToGraderReports < ActiveRecord::Migration[5.1]
  def self.up
    add_column :grader_reports, :reportable_id, :integer
    add_column :grader_reports, :reportable_type, :string
    GraderReport.find_each do |report|
      report.update(reportable_id: report.business_id, reportable_type: 'Business')
    end
    remove_column :grader_reports, :business_id, :integer
  end

  def self.down
    add_column :grader_reports, :business_id, :integer
    GraderReport.find_each do |report|
      report.update(business_id: report.reportable_id)
    end
    remove_column :grader_reports, :reportable_id, :integer
    remove_column :grader_reports, :reportable_type, :string
  end
end
