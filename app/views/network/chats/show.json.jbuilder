json.extract! @message, :id, :sender_id, :receiver_id, :message
json.url network_chat_url(@message, format: :json)
