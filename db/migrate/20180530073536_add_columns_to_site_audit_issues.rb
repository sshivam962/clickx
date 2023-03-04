class AddColumnsToSiteAuditIssues < ActiveRecord::Migration[5.1]
  def change
    add_column :site_audit_issues, :page_id, :string
    add_column :site_audit_issues, :leo_api_datum_id, :integer
    add_column :site_audit_issues, :backlinks_count, :integer
    add_column :site_audit_issues, :keywords, :integer
    add_column :site_audit_issues, :traffic_metrics, :integer
    add_column :site_audit_issues, :readability_note, :string
    add_column :site_audit_issues, :site_audit_detail_id, :integer
  end
end
