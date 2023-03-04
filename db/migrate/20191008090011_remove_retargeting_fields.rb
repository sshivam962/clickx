class RemoveRetargetingFields < ActiveRecord::Migration[5.1]
  def change
    remove_column :businesses, :retargeting_client_id, :string
    remove_column :businesses, :retargeting_cost_markup, :float, :default => 0
    remove_column :businesses, :retargeting_campaign_ids, :string, :array => true, :default => []
    remove_column :businesses, :retargeting_budget, :float, default: 0
    remove_column :intelligence_caches, :last_30_days_retargeting_summary, :jsonb, default: {}
  end
end
