class AddLegalNameColumnToNetworkProfile < ActiveRecord::Migration[5.1]
  def change
    add_column :network_profiles, :legal_name, :string
  end
end
