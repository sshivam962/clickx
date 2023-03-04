class RemoveHubspotFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :hubspot_integration, :jsonb
  end
end
