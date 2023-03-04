class AddSiteAuditIssueIdToLeoApiData < ActiveRecord::Migration[5.1]
  def change
    add_column :leo_api_data, :site_audit_issue_id, :integer
  end
end
