class AddColumnsToDomainRankings < ActiveRecord::Migration[5.1]
  def change
    add_column :domain_rankings, :domain, :string
    add_column :domain_rankings, :rank, :integer
    remove_column :domain_rankings, :domain_rank, :jsonb
  end
end
