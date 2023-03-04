class AddDetailReportCsvToSiteAuditData < ActiveRecord::Migration[4.2]
  def change
    add_column :site_audit_data, :detailed_report_csv_url, :json, default: {}
  end
end
