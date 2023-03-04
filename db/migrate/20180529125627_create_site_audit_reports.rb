class CreateSiteAuditReports < ActiveRecord::Migration[5.1]
  def change
    create_table :site_audit_reports do |t|
      t.integer :site_audit_issue_id
      t.jsonb :title
      t.jsonb :description
      t.jsonb :h_tags
      t.jsonb :images
      t.jsonb :cta
      t.jsonb :page_links

      t.timestamps
    end
  end
end
