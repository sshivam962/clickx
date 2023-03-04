class CreateAdminPaymentLinkPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :admin_payment_link_plans do |t|
      t.string :description_line_1
      t.string :description_line_2
      t.float :amount
      t.integer :billing_category
      t.float :implementation_fee
      t.boolean :pay_with_implementation_fee
      t.string :stripe_plan_id
      t.datetime :deleted_at
      t.references :admin_payment_link, type: :uuid

      t.timestamps
    end
    add_index :admin_payment_link_plans, :deleted_at
  end
end
