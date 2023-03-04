class AddOrderPriceToContentOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :content_orders, :order_price, :float
  end
end
