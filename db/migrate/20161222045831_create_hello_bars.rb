class CreateHelloBars < ActiveRecord::Migration[4.2]
  def change
    create_table :hello_bars do |t|
      t.text :message
      t.string :button_text
      t.string :link
      t.string :logo
      t.string :theme
      t.references :tracker_website, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
