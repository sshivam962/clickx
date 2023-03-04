class AddBudgetFieldsToBusiness < ActiveRecord::Migration[4.2]
  def change
    add_column :businesses, :ppc_budget, :float, default: 0
    add_column :businesses, :display_budget, :float, default: 0
    add_column :businesses, :retargeting_budget, :float, default: 0
  end
end
