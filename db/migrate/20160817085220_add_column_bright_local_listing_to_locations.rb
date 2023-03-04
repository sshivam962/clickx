class AddColumnBrightLocalListingToLocations < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :bright_local_lisiting, :json, default: {}, null: false
    add_column :locations, :bright_local_campaign_id, :string
  end
end
