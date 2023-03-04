class CreateSubscriptions < ActiveRecord::Migration[4.2]
  def change
    create_table :subscriptions do |t|
      t.string :plan_name
      t.string :plan_handle
      t.integer :business_id
      t.string :chargify_sub_id

      t.timestamps null: false
    end
  end
end
