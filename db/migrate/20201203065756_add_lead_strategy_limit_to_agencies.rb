class AddLeadStrategyLimitToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :lead_strategy_limit, :integer
  end
end
