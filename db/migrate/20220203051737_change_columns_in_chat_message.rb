class ChangeColumnsInChatMessage < ActiveRecord::Migration[5.1]
  def change
    remove_column :chat_messages, :sender, :string
    remove_column :chat_messages, :receiver, :string
    add_reference :chat_messages, :sender, index: true, foreign_key: { to_table: :users }
    add_reference :chat_messages, :receiver, index: true, foreign_key: { to_table: :users }
  end
end
