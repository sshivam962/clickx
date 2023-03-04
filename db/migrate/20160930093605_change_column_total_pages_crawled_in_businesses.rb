class ChangeColumnTotalPagesCrawledInBusinesses < ActiveRecord::Migration[4.2]
  def change
    change_column_default(:businesses, :total_pages_crawled, 500)
  end
end
