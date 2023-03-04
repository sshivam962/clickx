class ChatMessage < ApplicationRecord
  belongs_to :chat_thread, touch: true
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  belongs_to :receiver, class_name: 'User', foreign_key: :receiver_id, optional: true

  after_create :notify_pusher, on: :create

  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }

  def notify_pusher
    Pusher.trigger(
      "chat_thread_#{chat_thread.id}", 'new_msg',
      {
        "user_type" => (sender.contractor? ? 'contractor' : 'agency'),
        "message" => message,
        "username" => sender.name,
        "time" => created_at.strftime("%d %b %I:%M:%S %P"),
        "chat_thread_id" => chat_thread.id,
        "message_time" => message_time,
        "logo" => chat_thread.agency.users.ids.include?(sender.id) ? chat_thread.agency.name[0] : sender.name[0],
        "message_id" => id,
        "receiver_name" => receiver.present? ? receiver.name : chat_thread.agency.users.first.name,
        "receiver_logo" => receiver.present? ? receiver.name[0] : chat_thread.agency.name[0],
        "unread_messages_count" => receiver.present? ? chat_thread.chat_messages.unread.where(receiver_id: receiver.id).count : chat_thread.chat_messages.unread.where(receiver_id: nil).count,
        "unopened_chat_threads" => receiver.present? ? receiver.chat_threads.select {|chat_thread| chat_thread.chat_messages.unread.present?}.count : ''
      }
    )
  end

  def message_time
    if created_at.to_date.eql?(Date.current)
      created_at.strftime("%l:%M %p")
    else
      created_at.strftime("%d/%m/%y")
    end
  end
end
