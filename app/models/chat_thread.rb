class ChatThread < ApplicationRecord
  belongs_to :user
  belongs_to :agency

  has_many :chat_messages, dependent: :destroy

  after_create :notify_pusher, on: :create

  def notify_pusher
    Pusher.trigger("new_thread_#{agency_id}", 'new_thread', { })

    Pusher.trigger(
      "new_thread_#{user_id}", 'new_thread',
      {
        "chat_thread_id" => id,
        "username" => agency.users.first.name,
        "logo" => agency.name[0]
      }
    )
  end

  def latest_message
    chat_messages.order(created_at: :desc).first
  end
end
