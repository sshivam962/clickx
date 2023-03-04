class CreateFixedPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :fixed_plans do |t|
      t.references :agency
      t.references :package
      t.references :plan

      t.timestamps
    end
  end
end
