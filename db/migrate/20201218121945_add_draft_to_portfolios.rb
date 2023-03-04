class AddDraftToPortfolios < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :draft, :boolean
  end
end
