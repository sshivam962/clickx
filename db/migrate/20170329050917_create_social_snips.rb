class CreateSocialSnips < ActiveRecord::Migration[4.2]
  def change
    create_table :social_snips do |t|
      t.string :url
      t.string :logo
      t.string :content
      t.string :brand_name
      t.string :button_link
      t.string :button_text
      t.references :business, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
