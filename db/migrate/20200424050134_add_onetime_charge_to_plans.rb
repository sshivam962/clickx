class AddOnetimeChargeToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :onetime_charge, :float
  end
end
