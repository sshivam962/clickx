class ChangeNetworkProfileAssociationToUserInChatThead < ActiveRecord::Migration[5.1]
  def change
    remove_reference :chat_threads, :network_profile, index: true, foreign_key: true
    add_reference :chat_threads, :user, index: true, foreign_key: true
  end
end
