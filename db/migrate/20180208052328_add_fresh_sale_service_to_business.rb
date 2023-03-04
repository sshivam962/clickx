class AddFreshSaleServiceToBusiness < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :fresh_sale_service, :boolean, default: false
  end
end
