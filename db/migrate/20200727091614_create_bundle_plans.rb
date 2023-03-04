class CreateBundlePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :bundle_plans do |t|
      t.string :name
      t.string :key
      t.string :product_name
      t.float :amount
      t.integer :billing_category
      t.string :interval
      t.string :stripe_plan
      t.string :package_name
      t.string :package_type
      t.float :min_recommended_price
      t.boolean :business_required
      t.boolean :white_glove_service, default: false
      t.string :display_tag
      t.float :onetime_charge

      t.references :bundle_package
      t.timestamps
    end
  end
end
