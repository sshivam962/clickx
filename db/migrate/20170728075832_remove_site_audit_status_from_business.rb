class RemoveSiteAuditStatusFromBusiness < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :site_audit_status, :boolean
  end
end
