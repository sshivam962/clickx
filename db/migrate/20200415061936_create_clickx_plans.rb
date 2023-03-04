class CreateClickxPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :clickx_plans do |t|
      t.string :name
      t.string :key
      t.string :product_name
      t.float :amount
      t.integer :billing_category
      t.string :interval
      t.string :stripe_plan
      t.string :package_name
      t.string :package_type
      t.float :implementation_fee
      t.string :display_tag
      t.bigint :clickx_package_id

      t.timestamps
    end
  end
end
