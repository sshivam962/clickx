class AddSummaryPageDataToSiteAuditData < ActiveRecord::Migration[4.2]
  def change
    add_column :site_audit_data, :summary_page_data, :json, default: {}
  end
end
