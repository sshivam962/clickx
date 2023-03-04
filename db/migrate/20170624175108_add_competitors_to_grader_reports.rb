class AddCompetitorsToGraderReports < ActiveRecord::Migration[4.2]
  def change
    add_column :grader_reports, :organic_competitors, :jsonb, default: {}
    add_column :grader_reports, :adwords_competitors, :jsonb, default: {}
  end
end
