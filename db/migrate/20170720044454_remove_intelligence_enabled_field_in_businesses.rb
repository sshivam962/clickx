class RemoveIntelligenceEnabledFieldInBusinesses < ActiveRecord::Migration[4.2]
  def change
    remove_column :businesses, :intelligence_enabled, :boolean
  end
end
