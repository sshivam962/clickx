class AddOldStrategyToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :old_strategy, :boolean, default: false
  end
end
