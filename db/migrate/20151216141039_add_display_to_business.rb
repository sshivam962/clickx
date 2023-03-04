class AddDisplayToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :display_client_id, :string
    add_column :businesses, :display_cost_markup, :float, :default => 0
    add_column :businesses, :display_campaign_ids, :string, :array => true, :default => []
    add_column :businesses, :display_service, :boolean
  end
end
