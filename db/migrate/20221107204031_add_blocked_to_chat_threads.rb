class AddBlockedToChatThreads < ActiveRecord::Migration[5.2]
  def change
    add_column :twillio_chat_threads, :blocked, :boolean, default: false
  end
end
