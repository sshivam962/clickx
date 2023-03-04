class AddFbBudgetToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :fb_budget, :float, default: 0.0
  end
end
