class RemoveForeignKeyFromTrackerContactIntegrations < ActiveRecord::Migration[4.2]
  def change
    remove_foreign_key :tracker_contact_form_integrations, column: :ownable_id
  end
end
