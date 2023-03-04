class AddTotalPagesCrawledToDeepCrawlData < ActiveRecord::Migration[4.2]
  def change
    add_column :deep_crawl_data, :total_pages_crawled, :integer
  end
end
