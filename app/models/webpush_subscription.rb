# frozen_string_literal: true

class WebpushSubscription < ApplicationRecord
  validates :endpoint, :p256dh, :auth, :user_id, presence: true
  belongs_to :user

  scope :mozilla, -> { where("endpoint like '%mozilla%'") }
  scope :fcm, -> { where("endpoint like '%fcm.googleapis.com%'") }
  scope :gcm, -> { where("endpoint like '%/gcm/send%'") }

  def send_message(message)
    Webpush.payload_send(message: message,
                         endpoint: endpoint,
                         p256dh: p256dh,
                         auth: auth,
                         vapid: {
                           subject: 'mailto:sender@example.com',
                           public_key: ENV['VAPID_PUBLIC_KEY'],
                           private_key: ENV['VAPID_PRIVATE_KEY']
                         })
  end

  def content; end
end
