class AddIntelligenceToBusinesses < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :intelligence_enabled, :boolean, default: true
  end
end
