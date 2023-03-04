class CreateVideos < ActiveRecord::Migration[4.2]
  def change
    create_table :videos do |t|
      t.string :title
      t.text :embed_code
      t.text :description
      t.string :category

      t.timestamps null: false
    end
  end
end
