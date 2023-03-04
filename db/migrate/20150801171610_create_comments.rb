class CreateComments < ActiveRecord::Migration[4.2]
  def change
    create_table :comments do |t|
      t.text :comment
      t.integer :content_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
