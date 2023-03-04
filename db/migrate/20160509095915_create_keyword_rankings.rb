class CreateKeywordRankings < ActiveRecord::Migration[4.2]
  def change
    create_table :keyword_rankings do |t|
      t.integer :google_rank
      t.integer :google_change
      t.text    :google_url
      t.integer :bing_rank
      t.integer :bing_change
      t.text    :bing_url
      t.date    :rank_date
      t.integer :business_keyword_id

      t.timestamps null: false
    end
  end
end
