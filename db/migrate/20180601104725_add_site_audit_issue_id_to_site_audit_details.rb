class AddSiteAuditIssueIdToSiteAuditDetails < ActiveRecord::Migration[5.1]
  def change
    add_column :site_audit_details, :site_audit_issue_id, :integer
  end
end
