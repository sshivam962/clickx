class AddPortfolioEnabledToAgencies < ActiveRecord::Migration[5.1]
  def change
    add_column :agencies, :portfolio_enabled, :boolean, default: false
  end
end
