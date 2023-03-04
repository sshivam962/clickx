class AddIndexToPortfolios < ActiveRecord::Migration[5.1]
  def change
  	add_index :portfolios, :agency_id
  end
end
