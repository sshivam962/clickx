class CreateSocialMedia < ActiveRecord::Migration[4.2]
  def change
    create_table :social_media do |t|
      t.string :site
      t.string :page_id
      t.string :post_id
      t.references :social_post

      t.timestamps null: false
    end
  end
end
