class Twillio::ChatThread < ApplicationRecord
  self.table_name_prefix = 'twillio_'

  validates :contact_phone, presence: true, uniqueness: true

  belongs_to :contact, class_name: 'Twillio::Contact', foreign_key: :contact_phone, primary_key: :phone
  has_many :messages, -> { order(created_at: :asc) }, class_name: 'Twillio::Message', foreign_key: :twillio_chat_thread_id

  has_one :latest_message, class_name: 'Twillio::Message', foreign_key: :twillio_chat_thread_id

  delegate :display_name, to: :contact
  delegate :user_name, to: :contact, allow_nil: true
  delegate :body, to: :latest_message

  scope :non_blocked, -> { where(blocked: false) }

  def add_sms(sms, user_id)
    messages.create(
      sid: sms.sid,
      body: sms.body,
      from: sms.from,
      to: sms.to,
      status: :sent,
      user_id: user_id
    )
  end
end
