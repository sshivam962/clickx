
class CreateSearchResultRankings < ActiveRecord::Migration[5.1]
  def change
    create_table :search_result_rankings do |t|
      t.string :href
      t.string :base_url
      t.string :title
      t.string :description
      t.integer :rank
      t.integer :last_7_days
      t.integer :last_14_days
      t.integer :last_30_days
      t.integer :search_term_id
      t.date    :rank_date

      t.timestamps
    end
  end
end
