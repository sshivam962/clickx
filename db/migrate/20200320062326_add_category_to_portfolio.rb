class AddCategoryToPortfolio < ActiveRecord::Migration[5.1]
  def change
    add_column :portfolios, :category, :integer
  end
end
