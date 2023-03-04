class AddGoogleApiVersionToGraderReports < ActiveRecord::Migration[5.1]
  def up
    add_column :grader_reports, :google_api_version, :string

    GraderReport.update_all(google_api_version: 'v2')
  end

  def down
    remove_column :grader_reports, :google_api_version
  end
end
