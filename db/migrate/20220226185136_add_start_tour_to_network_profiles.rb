class AddStartTourToNetworkProfiles < ActiveRecord::Migration[5.1]
  def change
    add_column :network_profiles, :start_tour, :integer
  end
end
