class AddAdrollIntegrationToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :adroll_integration, :jsonb
    add_column :businesses, :adroll_service_enabled, :boolean, default: true
  end
end
