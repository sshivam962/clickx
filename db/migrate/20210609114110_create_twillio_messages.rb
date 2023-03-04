class CreateTwillioMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :twillio_messages, id: false do |t|
      t.string :sid, null: false
      t.integer :status
      t.string :body
      t.string :from
      t.string :to
      t.references :twillio_chat_thread

      t.timestamps
    end

    add_index :twillio_messages, :sid, unique: true
  end
end
