class AddLinkedinFieldToNetworkProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :network_profiles, :linkedin, :string
  end
end
