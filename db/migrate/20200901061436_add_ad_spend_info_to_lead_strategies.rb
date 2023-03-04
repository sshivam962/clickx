class AddAdSpendInfoToLeadStrategies < ActiveRecord::Migration[5.1]
  def change
    add_column :lead_strategies, :ad_spend_info, :text
  end
end
