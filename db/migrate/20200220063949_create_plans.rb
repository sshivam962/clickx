class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
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
      t.float :min_recommended_price
      t.boolean :business_required
      t.string :display_tag

      t.references :package, index: true

      t.timestamps
    end
  end
end
