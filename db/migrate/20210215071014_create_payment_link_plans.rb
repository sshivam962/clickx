class CreatePaymentLinkPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :payment_link_plans do |t|
      t.string :description_line_1
      t.string :description_line_2
      t.float :amount
      t.integer :billing_category
      t.float :implementation_fee
      t.boolean :pay_with_implementation_fee
      t.string :stripe_plan_id

      t.references :payment_link
      t.timestamps
    end
  end
end
