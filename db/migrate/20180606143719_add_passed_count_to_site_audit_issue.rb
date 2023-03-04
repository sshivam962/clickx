class AddPassedCountToSiteAuditIssue < ActiveRecord::Migration[5.1]
  def change
    add_column :site_audit_issues, :passed_count, :integer
  end
end
