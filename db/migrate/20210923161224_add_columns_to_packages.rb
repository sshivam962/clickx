class AddColumnsToPackages < ActiveRecord::Migration[5.1]
  def change
    add_column :packages, :ensure_checklist, :text, array: true
  end
end