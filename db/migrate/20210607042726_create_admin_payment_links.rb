class CreateAdminPaymentLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_payment_links, id: :uuid do |t|
      t.string :name
      t.string :email
      t.integer :status, default: 0
      t.boolean :disabled, default: false
      t.string :stripe_customer_id
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :admin_payment_links, :deleted_at
  end
end
