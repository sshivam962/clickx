class CreateNetworkPortfolios < ActiveRecord::Migration[5.1]
  def change
    create_table :network_portfolios do |t|
      t.references :network_profile, foreign_key: true
      t.string :heading
      t.text :paragraph

      t.timestamps
    end
  end
end
