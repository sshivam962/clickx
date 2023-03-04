class AddDetailedReportToLeoApiData < ActiveRecord::Migration[4.2]
  def change
    add_column :leo_api_data, :detailed_report, :json
  end
end
