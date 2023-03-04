class RemoveColumnsFromBusinesses < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :deepcrawl_project_id, :string
    remove_column :businesses, :deep_crawl_id, :string
  end
end
