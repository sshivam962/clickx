class CreateKeywordRankingRawResults < ActiveRecord::Migration[4.2]
  def change
    create_table :keyword_ranking_raw_results do |t|
      t.json :search_result
      t.json :keyword_callback

      t.timestamps null: false
    end
  end
end
