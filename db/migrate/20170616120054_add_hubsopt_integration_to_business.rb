class AddHubsoptIntegrationToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :hubspot_integration, :jsonb
  end
end
