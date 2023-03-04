class CreateChatMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_messages do |t|
      t.references :chat_thread, foreign_key: true
      t.string :sender
      t.string :receiver
      t.text :message

      t.timestamps
    end
  end
end
