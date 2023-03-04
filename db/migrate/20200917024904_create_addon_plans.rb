class CreateAddonPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :addon_plans do |t|
      t.bigint :package_id
      t.bigint :plan_id

      t.timestamps
    end
  end
end
