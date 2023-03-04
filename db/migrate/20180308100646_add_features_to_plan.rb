class AddFeaturesToPlan < ActiveRecord::Migration[5.1]
  def change
    add_column :subscription_plans, :features, :string, array: true, default: []
  end
end
