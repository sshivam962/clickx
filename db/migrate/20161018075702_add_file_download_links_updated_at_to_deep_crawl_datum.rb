class AddFileDownloadLinksUpdatedAtToDeepCrawlDatum < ActiveRecord::Migration[4.2]
  def change
    add_column :deep_crawl_data, :download_links_updated_at, :datetime
  end
end
