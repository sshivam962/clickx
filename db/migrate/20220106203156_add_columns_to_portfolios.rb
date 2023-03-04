class AddColumnsToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :agency_id, :integer, default: 0
  end
end