class RenameColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :site_audit_issue_infos, :description, :error_description
  end
end
