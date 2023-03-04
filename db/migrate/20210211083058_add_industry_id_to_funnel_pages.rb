class AddIndustryIdToFunnelPages < ActiveRecord::Migration[5.1]
  def change
    add_reference :funnel_pages, :industry, foreign_key: true
  end
end
