class RemoveSiteAuditIssueIdFromSiteAuditDetail < ActiveRecord::Migration[5.1]
  def change
    remove_column :site_audit_details, :site_audit_issue_id, :integer
  end
end
