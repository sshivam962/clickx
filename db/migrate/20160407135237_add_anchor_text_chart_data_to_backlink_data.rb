class AddAnchorTextChartDataToBacklinkData < ActiveRecord::Migration[4.2]
  def change
    add_column :backlink_data, :anchor_chart_data, :json
    add_column :backlink_data, :anchor_chart_data_updated_at, :datetime
  end
end
