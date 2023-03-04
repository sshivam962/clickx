class Twillio::Message < ApplicationRecord
  self.table_name_prefix = 'twillio_'
  self.primary_key = 'sid'

  validates :status, presence: true

  enum status: %i[received sent]

  belongs_to :chat_thread, class_name: 'Twillio::ChatThread', foreign_key: :twillio_chat_thread_id, touch: true
  belongs_to :sender, class_name: 'Twillio::Contact', foreign_key: :from, primary_key: :phone
  belongs_to :receiver, class_name: 'Twillio::Contact', foreign_key: :to, primary_key: :phone
  belongs_to :user, optional: true
end
