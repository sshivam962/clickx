class AddFbAdCostMarkupToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :fb_ad_cost_markup, :float, default: 0.0
  end
end
