class AddIssuesDataToDeepCrawlData < ActiveRecord::Migration[4.2]
  def change
    add_column :deep_crawl_data, :issues_data, :json
  end
end
