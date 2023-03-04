class RemoveFreshsaleFromBusinesses < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :fresh_sale_auth_token, :string
    remove_column :businesses, :fresh_sale_domain, :string
    remove_column :businesses, :fresh_sale_service, :boolean, default: false
  end
end
