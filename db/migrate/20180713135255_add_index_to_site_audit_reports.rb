class AddIndexToSiteAuditReports < ActiveRecord::Migration[5.1]
  def change
    add_index :site_audit_reports, :site_audit_issue_id
  end
end
