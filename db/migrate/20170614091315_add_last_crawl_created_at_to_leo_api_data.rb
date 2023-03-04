class AddLastCrawlCreatedAtToLeoApiData < ActiveRecord::Migration[4.2]
  def change
    add_column :leo_api_data, :last_crawl_created_at, :datetime
  end
end
