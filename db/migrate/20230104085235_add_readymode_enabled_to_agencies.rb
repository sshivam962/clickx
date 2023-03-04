class AddReadymodeEnabledToAgencies < ActiveRecord::Migration[5.2]
  def change
    add_column :agencies, :readymode_enabled, :boolean, default: false
  end
end
