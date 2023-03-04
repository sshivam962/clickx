class AddStatusToGraderReports < ActiveRecord::Migration[5.1]
  def up
    add_column :grader_reports, :status, :integer
    GraderReport.update_all(status: :completed)
  end

  def down
    remove_column :grader_reports, :status
  end
end
