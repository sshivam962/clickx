class AddIndexToSiteAuditIssues < ActiveRecord::Migration[5.1]
  def change
    add_index :site_audit_issues, :leo_api_datum_id
    add_index :site_audit_issues, :page_id
  end
end
