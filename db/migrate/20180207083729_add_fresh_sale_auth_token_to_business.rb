class AddFreshSaleAuthTokenToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :fresh_sale_auth_token, :string
  end
end
