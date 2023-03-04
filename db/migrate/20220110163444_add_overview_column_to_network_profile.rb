class AddOverviewColumnToNetworkProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :network_profiles, :overview, :text
  end
end
