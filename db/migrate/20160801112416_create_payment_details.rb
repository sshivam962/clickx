class CreatePaymentDetails < ActiveRecord::Migration[4.2]
  def change
    create_table :payment_details do |t|
      t.string :payment_type, default: 'credit_card'
      t.integer :business_id
      t.string :email
      t.string :card_token
      t.string :card_info
      t.string :stripe_customer_id
      t.string :name
      t.timestamps null: false
    end
    add_index :payment_details, :business_id
  end
end
