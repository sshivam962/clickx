class AddBacklinksInfoToGraderReports < ActiveRecord::Migration[4.2]
  def change
    add_column :grader_reports, :backlinks, :jsonb, default: {}
  end
end
