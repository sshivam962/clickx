class AddTierToPortfolios < ActiveRecord::Migration[5.1]
  def up
    add_column :portfolios, :tier, :integer
    Portfolio.update_all(tier: :free)
  end

  def down
    remove_column :portfolios, :tier
  end
end
