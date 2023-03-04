class AddFieldsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :wufoo_account_name, :string
    add_column :businesses, :wufoo_api_key, :string
    add_column :businesses, :unbounce_key, :string
  end
end
