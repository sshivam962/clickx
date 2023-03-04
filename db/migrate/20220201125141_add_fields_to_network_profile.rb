class AddFieldsToNetworkProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :network_profiles, :facebook, :string
    add_column :network_profiles, :instagram, :string
    add_column :network_profiles, :dribbble, :string
  end
end
