class CreateSiteAuditDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :site_audit_details do |t|
      t.string :title
      t.string :description
      t.string :h_tags
      t.string :images
      t.string :cta
      t.string :page_links

      t.timestamps null: false
    end
  end
end
