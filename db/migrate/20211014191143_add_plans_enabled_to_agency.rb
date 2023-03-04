class AddPlansEnabledToAgency < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :plans_enabled, :boolean, default: true
  end
end
