class AddUnreadToTwillioChatThreads < ActiveRecord::Migration[5.2]
  def change
    add_column :twillio_chat_threads, :unread, :boolean, default: false
  end
end
