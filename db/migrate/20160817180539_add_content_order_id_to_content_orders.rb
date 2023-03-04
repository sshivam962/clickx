class AddContentOrderIdToContentOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :content_orders, :content_order_id, :string
  end
end
