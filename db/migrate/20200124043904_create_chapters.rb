class CreateChapters < ActiveRecord::Migration[5.1]
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :video_embed_code
      t.text :description

      t.timestamps

      t.references :course, index: true
    end
  end
end
