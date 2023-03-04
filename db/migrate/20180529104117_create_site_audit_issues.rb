class CreateSiteAuditIssues < ActiveRecord::Migration[5.1]
  def change
    create_table :site_audit_issues do |t|
      t.string :url
      t.float :readability_score
      t.integer :links
      t.integer :errors_count
      t.integer :warning_count

      t.timestamps
    end
  end
end
