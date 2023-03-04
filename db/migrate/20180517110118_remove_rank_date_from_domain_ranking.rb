class RemoveRankDateFromDomainRanking < ActiveRecord::Migration[5.1]
  def change
    remove_column :domain_rankings, :rank_date, :datetime
  end
end
