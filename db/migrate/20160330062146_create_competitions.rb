class CreateCompetitions < ActiveRecord::Migration[4.2]
  def change
    create_table :competitions do |t|
      t.string :name
      t.integer :business_id
      t.json :summary, default: {}, null: false
      t.json :backlinks, default: {}, null: false
      t.json :anchor_text, default: {}, null: false
      t.json :top_pages, default: {}, null: false

      t.timestamps null: false
    end
  end
end
