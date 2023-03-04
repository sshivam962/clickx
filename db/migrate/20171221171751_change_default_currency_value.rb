class ChangeDefaultCurrencyValue < ActiveRecord::Migration[5.1]
  def change
    change_column_default :subscription_plans, :currency, from: 'USD', to: 'usd'
    change_column_default :subscription_coupons, :currency, from: 'USD', to: 'usd'
  end
end
