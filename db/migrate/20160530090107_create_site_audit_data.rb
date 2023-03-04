class CreateSiteAuditData < ActiveRecord::Migration[4.2]
  def change
    create_table :site_audit_data do |t|
      t.integer :project_id
      t.integer :business_id
      t.integer :crawl_id
      t.json :crawl_summary

      t.timestamps null: false
    end
  end
end
