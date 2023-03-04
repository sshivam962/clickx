class AddDeepCrawlTokenLastUpdatedAtToAgencies < ActiveRecord::Migration[4.2]
  def change
    add_column :agencies, :deepcrawl_token_updated_at, :datetime
  end
end
