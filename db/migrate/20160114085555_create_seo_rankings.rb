class CreateSeoRankings < ActiveRecord::Migration[4.2]
  def change
    create_table :seo_rankings do |t|
      t.integer :business_id
      t.json :keyword_data, default: {}, null: false
      t.json :date_data, default: {}, null: false

      t.timestamps null: false
    end
  end
end
