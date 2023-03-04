class SentEmail < ApplicationRecord
  belongs_to :domain_contact, counter_cache: true
  belongs_to :sender ,
    class_name: 'User', foreign_key: :sender_id, optional: true
  belongs_to :verifier, -> { with_deleted },
    class_name: 'User', foreign_key: :verified_by, optional: true

  scope :order_by_sent, -> { order(email_sent_at: :asc) }

  scope :contacted_today, (lambda do
    where(
      email_queued_at: Time.current.beginning_of_day..Time.current.end_of_day
    )
  end)

  scope :contacted_yesterday, (lambda do
    where(
      email_queued_at: Time.current.yesterday.beginning_of_day..Time.current.yesterday.end_of_day
    )
  end)

  scope :verified_today, (lambda do
    where(
      verified_at: Time.current.beginning_of_day..Time.current.end_of_day
    )
  end)

  scope :verified_yesterday, (lambda do
    where(
      verified_at: Time.current.yesterday.beginning_of_day..Time.current.yesterday.end_of_day
    )
  end)

  def verified?
    verified_at.present?
  end

  def email_status
    sent_time = verified_at&.strftime("%b %d, %Y")
    if sender.present? && verified? && verifier.present?
      if sender == verifier
        "Sent and Verified by #{verifier.name} at #{sent_time}"
      else
        "Sent by #{sender.name} and Verified by #{verifier.name} at #{sent_time}"
      end
    elsif verified? && verifier.present?
      "Verified by #{verifier.name} at #{sent_time}"
    elsif sender.present?
      "Sent by #{sender.name}"
    else
      'Not Contacted'
    end
  end
end
