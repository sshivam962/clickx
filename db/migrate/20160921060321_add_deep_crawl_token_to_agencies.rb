class AddDeepCrawlTokenToAgencies < ActiveRecord::Migration[4.2]
  def change
    add_column :agencies, :deepcrawl_token, :string
  end
end
