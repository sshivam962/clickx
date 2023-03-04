class AddSiteAuditStatusToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :site_audit_status, :boolean, default: false
  end
end
