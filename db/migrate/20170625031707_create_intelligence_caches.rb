class CreateIntelligenceCaches < ActiveRecord::Migration[4.2]
  def change
    create_table :intelligence_caches do |t|
      t.references :business, index: true, foreign_key: true
      t.jsonb :best_performing_ads, default: []
      t.jsonb :contacts_overview, default: {}
      t.jsonb :contacts_per_day, default: {}
      t.jsonb :new_contacts_by_source, default: {}
      t.jsonb :top_10_keywords, default: []

      t.timestamps null: false
    end
  end
end
