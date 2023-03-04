class AddDeletedAtToLeadStrategies < ActiveRecord::Migration[5.1]
  def change
    add_column :lead_strategies, :deleted_at, :datetime
  end
end
