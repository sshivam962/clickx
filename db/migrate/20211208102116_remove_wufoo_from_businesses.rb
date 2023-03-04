class RemoveWufooFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :wufoo_account_name, :string
    remove_column :businesses, :wufoo_api_key, :string
    remove_column :businesses, :wufoo_enabled, :boolean, default: false
    remove_column :businesses, :wufoo_ids, :string, array: true, default: []
  end
end
