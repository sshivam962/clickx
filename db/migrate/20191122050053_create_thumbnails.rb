class CreateThumbnails < ActiveRecord::Migration[5.1]
  def up
    create_table :thumbnails do |t|
      t.string :file
      t.references :thumbnailable, polymorphic: true

      t.timestamps
    end
  end

  def down
    change_table :thumbnails do |t|
      t.remove_references :thumbnailable, polymorphic: true
    end
  end
end
