class CreateTagColors < ActiveRecord::Migration[5.1]
  def change
    create_table :tag_colors do |t|
      t.string :tag, null: false
      t.string :color, null: false
      t.integer :business_id, null: false, index: true
      t.timestamps
    end
  end
end
