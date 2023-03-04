class AddLastCrawlCreatedAtToDeepCrawlData < ActiveRecord::Migration[4.2]
  def change
    add_column :deep_crawl_data, :last_crawl_created_at, :datetime
  end
end
