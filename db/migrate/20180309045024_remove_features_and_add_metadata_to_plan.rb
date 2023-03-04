class RemoveFeaturesAndAddMetadataToPlan < ActiveRecord::Migration[5.1]
  def up
    remove_column :subscription_plans, :features
    add_column :subscription_plans, :metadata, :json, default: {}
  end

  def down
    remove_column :subscription_plans, :metadata
    add_column :subscription_plans, :features, :string, array: true, default: []
  end
end
