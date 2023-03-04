class DropTableSiteAuditDatum < ActiveRecord::Migration[4.2]
  def change
    drop_table :site_audit_data
  end
end
