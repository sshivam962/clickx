class CreateSiteAuditIssueInfos < ActiveRecord::Migration[4.2]
  def change
    create_table :site_audit_issue_infos do |t|
      t.string :description
      t.string :issue_type

      t.timestamps null: false
    end
  end
end
