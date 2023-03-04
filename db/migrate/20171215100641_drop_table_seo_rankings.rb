class DropTableSeoRankings < ActiveRecord::Migration[5.1]
  def up
    drop_table :seo_rankings
  end

  def down
    create_table :seo_rankings do |t|
      t.integer :business_id
      t.json :keyword_data, default: {}, null: false
      t.json :date_data, default: {}, null: false

      t.timestamps null: false
    end

    add_index :seo_rankings, :business_id
  end
end
