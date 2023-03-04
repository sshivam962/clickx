class AddPassedDescriptionToSiteAuditIssueInfos < ActiveRecord::Migration[4.2]
  def change
    add_column :site_audit_issue_infos, :passed_description, :string
  end
end
