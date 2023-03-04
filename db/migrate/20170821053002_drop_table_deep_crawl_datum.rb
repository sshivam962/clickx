class DropTableDeepCrawlDatum < ActiveRecord::Migration[4.2]
  def change
    drop_table :deep_crawl_data
  end
end
