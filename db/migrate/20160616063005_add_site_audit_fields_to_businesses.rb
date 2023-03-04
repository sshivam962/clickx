class AddSiteAuditFieldsToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :deepcrawl_project_id, :string
    add_column :businesses, :deep_crawl_id, :string
  end
end
