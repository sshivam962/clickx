class AddTitleToSiteAuditIssueInfos < ActiveRecord::Migration[4.2]
  def change
    add_column :site_audit_issue_infos, :error_title, :string
    add_column :site_audit_issue_infos, :passed_title, :string
  end
end
