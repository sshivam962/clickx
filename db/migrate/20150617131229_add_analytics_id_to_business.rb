class AddAnalyticsIdToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :google_analytics_service, :boolean, default: false
    add_column :businesses, :google_analytics_id, :string
  end
end
