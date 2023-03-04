class Agency::ChatsController < Agency::BaseController
  before_action :set_thread, only: %i[create chat_history unread_messages]

  def index
    @chat_threads = current_agency.chat_threads.order(updated_at: :desc)
  end

  def create
    @chat_thread.chat_messages.create(
      chat_params.merge(
        sender_id: current_user.id,
        receiver_id: @chat_thread.user_id
      )
    )
  end

  def chat_history
    @messages = @chat_thread.chat_messages.order(created_at: :desc).paginate(
      page: params[:page] || 1, per_page: 10
    )
    @unread_messages = @chat_thread.chat_messages.unread.where(receiver_id: nil).present?
  end

  def unread_messages
    @chat_thread.chat_messages.unread.where(receiver_id: nil).update_all(read: true)
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
    @chat_thread = current_agency.chat_threads.find(params[:thread_id])
  end
end
