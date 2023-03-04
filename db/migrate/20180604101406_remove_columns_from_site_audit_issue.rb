class RemoveColumnsFromSiteAuditIssue < ActiveRecord::Migration[5.1]
  def change
    remove_column :site_audit_issues, :site_audit_detail_id, :integer
    remove_column :site_audit_issues, :links, :integer
  end
end
