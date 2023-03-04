class CreateSemrushKeywords < ActiveRecord::Migration[5.1]
  def change
    create_table :semrush_keywords do |t|
      t.references :business, foreign_key: true
      t.string :keyword_id
      t.string :name
      t.string :cpc
      t.integer :last_day_google_change
      t.integer :last_week_google_change
      t.integer :last_30_days_google_change
      t.integer :search_volume
      t.integer :kdi
      t.integer :rank
      t.string :url

      t.timestamps
    end
  end
end
