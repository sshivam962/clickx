class CreateDeepCrawlData < ActiveRecord::Migration[4.2]
  def change
    create_table :deep_crawl_data do |t|
      t.integer :business_id
      t.integer :project_id
      t.integer :crawl_id
      t.json :graph_data
      t.json :summary_page

      t.timestamps null: false
    end
    add_index :deep_crawl_data, :business_id
  end
end
