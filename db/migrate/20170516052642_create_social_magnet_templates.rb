class CreateSocialMagnetTemplates < ActiveRecord::Migration[4.2]
  def change
    create_table :social_magnet_templates do |t|
      t.string :logo
      t.string :content
      t.string :brand_name
      t.string :button_link
      t.string :button_text
      t.references :business, foreign_key: true, index: true

      t.timestamps null: false
    end
  end
end
