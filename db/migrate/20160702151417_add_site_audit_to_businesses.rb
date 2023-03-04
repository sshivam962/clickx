class AddSiteAuditToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :site_audit_service, :boolean, default: false
  end
end
