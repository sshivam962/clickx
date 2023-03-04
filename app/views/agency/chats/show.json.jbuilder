json.extract! @message, :id, :sender_id, :receiver_id, :message
json.url agency_chat_url(@message, format: :json)
