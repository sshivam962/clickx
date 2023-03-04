class CreateChatThreads < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_threads do |t|
      t.references :network_profile, foreign_key: true
      t.references :agency, foreign_key: true

      t.timestamps
    end
  end
end
