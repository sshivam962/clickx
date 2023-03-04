class AddKeywordRankingDisabledColumnToBusinesses < ActiveRecord::Migration[5.1]
  def change
    add_column :businesses, :keyword_ranking_disabled, :boolean, default: false
  end
end
