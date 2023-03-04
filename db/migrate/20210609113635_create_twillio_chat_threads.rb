class CreateTwillioChatThreads < ActiveRecord::Migration[5.1]
  def change
    create_table :twillio_chat_threads do |t|
      t.string :contact_phone

      t.timestamps
    end
  end
end
