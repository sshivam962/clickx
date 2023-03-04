class AddSearchVolumeAndCpcToKeywordRanking < ActiveRecord::Migration[4.2]
  def change
    add_column :keyword_rankings, :search_volume, :string
    add_column :keyword_rankings, :cpc, :string
  end
end
