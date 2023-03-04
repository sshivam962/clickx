class AddCallAnalyticsIdToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :call_analytics_id, :string
  end
end
