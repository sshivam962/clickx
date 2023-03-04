class CreateSocialLinks < ActiveRecord::Migration[4.2]
  def change
    create_table :social_links do |t|
      
      t.string :link_type,    null: false
      t.string :link,         null: false

      t.references :location, index: true
      t.timestamps null: false
    end
  end
end
