class CreateContentOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :content_orders do |t|
      t.integer :business_id
      t.json :form_data
      t.integer :order_status, default: 0
      t.integer :payment_status, default: 0
      t.string :payment_information
      t.datetime :paid_on

      t.timestamps null: false
    end
    add_index :content_orders, :business_id
  end
end
