class Network::ChatsController < Network::BaseController
  before_action :set_thread, only: %i[create chat_history unread_messages]

  def index
    @chat_threads = current_user.chat_threads.order(updated_at: :desc)
  end

  def create
    @chat_thread.chat_messages.create(
      chat_params.merge(
        sender_id: current_user.id
      )
    )
  end

  def chat_history
    @messages = @chat_thread.chat_messages.order(created_at: :desc).paginate(
      page: params[:page].presence || 1, per_page: 10
    )
    @unread_messages = @chat_thread.chat_messages.unread.where(receiver_id: current_user.id).present?
  end

  def unread_messages
    @chat_thread.chat_messages.unread.where(receiver_id: current_user.id).update_all(read: true)
  end

  def update_message_read_status
    @message = ChatMessage.find(params[:message_id])
    @message.update(read: true)
  end

  private

  def chat_params
    params.permit(:message)
  end

  def set_thread
    @chat_thread = current_user.chat_threads.find(params[:thread_id])
  end
end
