class AddReadColumnToChatMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :chat_messages, :read, :boolean, default: false

    ChatMessage.update_all(read: true)
  end
end
