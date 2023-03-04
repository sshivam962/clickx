class AddCrawlStatusToDeepCrawlData < ActiveRecord::Migration[4.2]
  def change
    add_column :deep_crawl_data, :crawl_status, :integer
  end
end
