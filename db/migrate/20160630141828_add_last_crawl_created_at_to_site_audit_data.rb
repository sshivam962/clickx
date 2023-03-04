class AddLastCrawlCreatedAtToSiteAuditData < ActiveRecord::Migration[4.2]
  def change
    add_column :site_audit_data, :last_crawl_created_at, :datetime
  end
end
