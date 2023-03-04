class SetDefaultForCurrencyFieldInPlans < ActiveRecord::Migration[5.1]
  def change
    change_column_default :subscription_plans, :currency, from: nil, to: 'USD'
  end
end
