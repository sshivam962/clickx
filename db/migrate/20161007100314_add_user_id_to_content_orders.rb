class AddUserIdToContentOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :content_orders, :user_id, :integer
  end
end
