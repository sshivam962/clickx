class CreateBacklinkData < ActiveRecord::Migration[4.2]
  def change
    create_table :backlink_data do |t|
      t.integer :business_id
      t.json :summary
      t.json :backlinks
      t.json :anchor_text
      t.json :topics
      t.json :pages
      t.json :ref_domains

      t.timestamps null: false
    end
  end
end
