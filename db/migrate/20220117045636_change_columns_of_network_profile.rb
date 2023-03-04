class ChangeColumnsOfNetworkProfile < ActiveRecord::Migration[5.1]
  def change
    remove_column :network_profiles, :hours_of_work, :integer
    remove_column :network_profiles, :happy_client, :integer
    remove_column :network_profiles, :finished_project, :integer
    remove_column :network_profiles, :cups_of_coffee, :integer

    add_column :network_profiles, :stats, :json, default: {}
  end
end
