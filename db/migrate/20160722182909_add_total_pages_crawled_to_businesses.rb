class AddTotalPagesCrawledToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :total_pages_crawled, :integer, default: 5000
  end
end
