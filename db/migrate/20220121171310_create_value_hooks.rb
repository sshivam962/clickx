class CreateValueHooks < ActiveRecord::Migration[5.1]
  def change
    create_table :value_hooks do |t|
      t.string :title
      t.string :internal_title
      t.text :video_embed_code
      
      t.timestamps
    end
  end
end
