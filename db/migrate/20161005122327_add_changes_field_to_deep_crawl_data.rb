class AddChangesFieldToDeepCrawlData < ActiveRecord::Migration[4.2]
  def change
    add_column :deep_crawl_data, :change_data, :json
  end
end
